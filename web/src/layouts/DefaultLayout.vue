<template>
  <LeftSidebarNavigationDrawer
    v-model="showDrawer"
    :show-rail="showRail"
  />

  <v-app-bar
    flat
    color="secondary"
  >
    <v-app-bar-nav-icon
      color="#f7f9ef"
      @click="toggleDrawer"
    ></v-app-bar-nav-icon>
    <v-app-bar-title
      v-if="mdAndUp"
      class="ml-2 text-weight-bold"
      style="font-weight: bold"
      ><span style="color: #f7f9ef">{{ title }}</span></v-app-bar-title
    >
    <v-app-bar-title
      v-if="!mdAndUp"
      class="ml-2 text-weight-bold"
      style="font-weight: bold"
    >
      <router-link
        :to="{ name: 'DashboardPage' }"
        style="color: #f7f9ef; text-decoration: none"
        >Solid FM Accounting</router-link
      >
    </v-app-bar-title>

    <v-spacer />

    <NotificationMenu />

    <KebabMenu />
  </v-app-bar>

  <v-main>
    <SimpleBreadcrumbs />

    <v-container fluid>
      <router-view />
    </v-container>
  </v-main>
</template>

<script setup lang="ts">
import { ref, unref, watch } from "vue"
import { useDisplay } from "vuetify"

import useBreadcrumbs from "@/use/use-breadcrumbs"

import KebabMenu from "@/components/default-layout/KebabMenu.vue"
import LeftSidebarNavigationDrawer from "@/components/default-layout/LeftSidebarNavigationDrawer.vue"
import SimpleBreadcrumbs from "@/components/common/SimpleBreadcrumbs.vue"
import NotificationMenu from "@/components/common/layouts/NotificationMenu.vue"

const { mdAndUp } = useDisplay()

const showDrawer = ref(mdAndUp.value)
const showRail = ref(!mdAndUp.value)

const { title } = useBreadcrumbs()

watch(
  () => unref(mdAndUp),
  (newVal) => {
    if (!newVal) {
      showDrawer.value = true
      showRail.value = false
    } else {
      showDrawer.value = false
      showRail.value = true
    }
  }
)

function toggleDrawer() {
  if (!mdAndUp.value) showDrawer.value = !showDrawer.value
  else {
    showRail.value = !showRail.value
  }
}
</script>
