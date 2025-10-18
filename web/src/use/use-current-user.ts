import { computed, reactive, toRefs, unref } from "vue"
import { isEmpty, isNil, isUndefined } from "lodash"
import { DateTime } from "luxon"

import currentUserApi from "@/api/current-user-api"
import usersApi, { type User, UserRoles } from "@/api/users-api"

export { type User, UserRoles }

// TODO: consider sending this with every api request?
export const CURRENT_USERS_TIMEZONE = DateTime.local().zoneName

// Global state
const state = reactive<{
  currentUser: User | null
  isLoading: boolean
  isErrored: boolean
  isCached: boolean
}>({
  currentUser: null,
  isLoading: false,
  isErrored: false,
  isCached: false,
})

type State = typeof state
type LoadedState = Omit<State, "currentUser"> & {
  currentUser: Exclude<State["currentUser"], null>
}

export function useCurrentUser<IsLoaded extends boolean = false>() {
  type StateOrLoadedState = IsLoaded extends true ? LoadedState : State

  const isReady = computed(() => state.isCached && !state.isLoading && !state.isErrored)
  const isSystemAdmin = computed(() => {
    return state.currentUser?.roles.includes(UserRoles.SYSTEM_ADMIN)
  })
  const isGroupAdmin = computed(() => !isEmpty(state.currentUser?.adminGroups))
  const isCreatorGroupAdmin = computed(() => {
    return state.currentUser?.adminGroups?.some((group) => !group.isHost)
  })
  const isAdmin = computed(() => isSystemAdmin.value || isGroupAdmin.value)

  async function fetch(): Promise<User> {
    state.isLoading = true
    try {
      const { user } = await currentUserApi.get()
      state.isErrored = false
      state.currentUser = user
      state.isCached = true
      return user
    } catch (error) {
      console.error("Failed to fetch current user:", error)
      state.isErrored = true
      throw error
    } finally {
      state.isLoading = false
    }
  }

  async function save(): Promise<User> {
    if (isNil(state.currentUser)) {
      throw new Error("No user to save")
    }

    const staticId = unref(state.currentUser.id)
    if (isNil(staticId)) {
      throw new Error("id is required")
    }

    state.isLoading = true
    try {
      const { user } = await usersApi.update(staticId, state.currentUser)
      state.isErrored = false
      state.currentUser = user
      return user
    } catch (error) {
      console.error("Failed to save current user:", error)
      state.isErrored = true
      throw error
    } finally {
      state.isLoading = false
    }
  }

  // Needs to be called during logout or current user will persist.
  function reset() {
    state.currentUser = null
    state.isLoading = false
    state.isErrored = false
    state.isCached = false
  }

  // Helper functions
  function isGroupAdminFor(groupId: number) {
    if (isNil(state.currentUser)) {
      throw new Error("Expected currentUser to be non-null")
    }

    const { adminGroups } = state.currentUser
    if (isUndefined(adminGroups)) {
      throw new Error("Expected currentUser to have a adminGroups association")
    }

    return adminGroups.some((group) => group.id === groupId)
  }

  function isAdminForInformationSharingAgreement(informationSharingAgreementId: number) {
    if (isNil(state.currentUser)) {
      throw new Error("Expected currentUser to be non-null")
    }

    const { adminInformationSharingAgreementAccessGrants } = state.currentUser
    if (isUndefined(adminInformationSharingAgreementAccessGrants)) {
      throw new Error(
        "Expected currentUser to have a adminInformationSharingAgreementAccessGrants association"
      )
    }

    return adminInformationSharingAgreementAccessGrants.some(
      (accessGrant) => accessGrant.informationSharingAgreementId === informationSharingAgreementId
    )
  }

  return {
    ...toRefs(state as StateOrLoadedState),
    isReady,
    fetch,
    refresh: fetch,
    reset,
    save,
    // Computed properties
    isAdmin,
    isCreatorGroupAdmin,
    isGroupAdmin,
    isSystemAdmin,
    // Helper functions
    isGroupAdminFor,
    isAdminForInformationSharingAgreement,
  }
}

export default useCurrentUser
