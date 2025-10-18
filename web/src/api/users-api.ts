import http from "@/api/http-client"
import {
  type FiltersOptions,
  type Policy,
  type QueryOptions,
  type WhereOptions,
} from "@/api/base-api"
import { type Group } from "@/api/groups-api"
import { type InformationSharingAgreementAccessGrant } from "@/api/information-sharing-agreement-access-grants-api"

/** Keep in sync with api/src/models/user.ts */
export enum UserRoles {
  SYSTEM_ADMIN = "system_admin",
  USER = "user",
}

export type User = {
  id: number
  email: string
  auth0Subject: string
  firstName: string
  lastName: string
  displayName: string
  roles: UserRoles[]
  title: string | null
  department: string | null
  division: string | null
  branch: string | null
  unit: string | null
  deactivatedAt: string | null
  emailNotificationsEnabled: boolean
  createdAt: string
  updatedAt: string

  // Virtuals
  isActive: boolean

  // Associations
  adminGroups?: Group[]
  adminInformationSharingAgreementAccessGrants?: InformationSharingAgreementAccessGrant[]
}

export type UserReferenceView = Pick<
  User,
  | "id"
  | "email"
  | "firstName"
  | "lastName"
  | "displayName"
  | "title"
  | "department"
  | "division"
  | "branch"
  | "unit"
  | "emailNotificationsEnabled"
>

export type UserWhereOptions = WhereOptions<
  User,
  "email" | "title" | "department" | "division" | "branch" | "unit" | "emailNotificationsEnabled"
>

export type UserFiltersOptions = FiltersOptions<{
  search: string | string[]
  inGroup: number
  notInGroup: number
  withoutAccessGrantFor: number
  // TODO: implement isActive scope in back-end
}>

export type UserQueryOptions = QueryOptions<UserWhereOptions, UserFiltersOptions>

export const usersApi = {
  UserRoles,
  async list(params: UserQueryOptions = {}): Promise<{
    users: User[]
    totalCount: number
  }> {
    const { data } = await http.get("/api/users", {
      params,
    })
    return data
  },
  async get(userId: number): Promise<{
    user: User
    policy: Policy
  }> {
    const { data } = await http.get(`/api/users/${userId}`)
    return data
  },
  async create(attributes: Partial<User>): Promise<{
    user: User
  }> {
    const { data } = await http.post("/api/users", attributes)
    return data
  },
  async update(
    userId: number,
    attributes: Partial<User>
  ): Promise<{
    user: User
  }> {
    const { data } = await http.patch(`/api/users/${userId}`, attributes)
    return data
  },
  async delete(userId: number): Promise<void> {
    const { data } = await http.delete(`/api/users/${userId}`)
    return data
  },
}

export default usersApi
