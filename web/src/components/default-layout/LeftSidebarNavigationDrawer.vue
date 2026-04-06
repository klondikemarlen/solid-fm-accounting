<template>
  <v-navigation-drawer
    v-model="showDrawer"
    :disable-resize-watcher="false"
    :rail="showRail"
    :permanent="mdAndUp"
    :location="!mdAndUp ? 'bottom' : undefined"
    color="#a3a48d"
  >
    <v-list
      v-model:opened="open"
      class="pt-0"
      color="warning"
    >
      <v-list-item
        prepend-icon="mdi-library"
        style="height: 64px; opacity: 1"
        color="black"
        :to="{ name: 'DashboardPage' }"
      >
        <span class="text-h6">Home</span>
      </v-list-item>

    </v-list>
  </v-navigation-drawer>
</template>

<script setup lang="ts">
import { ref } from "vue"
import { useDisplay } from "vuetify"

const { mdAndUp } = useDisplay()

defineProps<{ showRail: boolean }>()

const showDrawer = defineModel<boolean>({
  default: false,
})

const open = ref([])
</script>
