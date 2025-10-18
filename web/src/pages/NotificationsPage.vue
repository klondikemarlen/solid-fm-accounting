<template>
  <h3 class="text-h3 mb-4">Notifications</h3>

  <AppCard>
    <v-btn-toggle
      v-model="showFilter"
      color="info"
      group
      mandatory
      style="border: 1px #b0b0b0 solid !important; border-radius: 6px"
    >
      <v-btn
        value="All"
        style="width: 100px; border-left: 1px #b0b0b0 solid"
        text="All"
      />
      <v-btn
        value="Unread"
        style="width: 100px; border-left: 1px #b0b0b0 solid"
        text="Unread"
      />
    </v-btn-toggle>

    TODO
  </AppCard>
</template>

<script lang="ts" setup>
import { useRouteQuery } from "@vueuse/router"
import { computed } from "vue"

import { stringTransformer } from "@/utils/use-route-query-transformers"

import { NotificationWhereOptions } from "@/use/use-notifications"


const routeQuerySuffix = "Notifications"

const showFilter = useRouteQuery<string>(`show${routeQuerySuffix}`, "All", {
  transform: stringTransformer,
})

const _where = computed<NotificationWhereOptions>(() => {
  if (showFilter.value === "Unread") {
    return { readAt: null }
  }

  return {}
})
</script>
