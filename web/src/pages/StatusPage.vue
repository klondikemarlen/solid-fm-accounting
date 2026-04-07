<template>
  <v-app>
    <v-container>
      <div class="mb-4 flex flex-wrap items-center gap-3 rounded-2xl border border-slate-300 bg-slate-50 px-4 py-3 text-sm shadow-sm">
        <span class="font-semibold text-slate-900">UnoCSS presetWind4 + Vuetify check</span>
        <v-chip
          color="primary"
          size="small"
        >
          Vuetify chip
        </v-chip>
        <span class="text-slate-600">
          Utilities handle layout and spacing while Vuetify still owns component styling.
        </span>
      </div>

      Return to <router-link :to="{ name: returnTo.name }">{{ returnTo.title }}</router-link>

      <v-row class="mt-5">
        <v-col cols="12">
          <v-card
            outlined
            class="pa-3"
            :loading="isLoading"
          >
            <v-card-title
              >Environment Information
              <v-btn
                class="ma-0 ml-1"
                icon
                size="small"
                color="green"
                title="refresh"
                @click="refresh"
              >
                <v-icon>mdi-cached</v-icon>
              </v-btn>
            </v-card-title>
            <v-list dense>
              <v-list-item> Release Tag: {{ environment.releaseTag }} </v-list-item>
              <v-list-item> Git Commit Hash: {{ environment.gitCommitHash }} </v-list-item>
            </v-list>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </v-app>
</template>

<script lang="ts" setup>
import { computed, onMounted, reactive, ref } from "vue"
import { useAuth0 } from "@auth0/auth0-vue"

import http from "@/api/http-client"

const { isAuthenticated } = useAuth0()

const returnTo = computed<{ name: string; title: string }>(() => {
  if (isAuthenticated.value) {
    return {
      name: "DashboardPage",
      title: "Dashboard",
    }
  }

  return {
    name: "SignInPage",
    title: "Sign In",
  }
})

const environment = reactive({
  releaseTag: "not-set",
  gitCommitHash: "not-set",
})

const isLoading = ref(true)

onMounted(async () => {
  await refresh()
})

async function fetchVersion() {
  return http
    .get("/_status")
    .then(({ data }) => {
      environment.releaseTag = data.RELEASE_TAG
      environment.gitCommitHash = data.GIT_COMMIT_HASH
      return data
    })
    .catch((error: unknown) => {
      console.error(`Error fetching version: ${error}`)
    })
}

async function refresh() {
  isLoading.value = true
  try {
    await fetchVersion()
  } catch (error) {
    console.error(`Error fetching version: ${error}`)
  } finally {
    isLoading.value = false
  }
}
</script>
