<template>
  <v-skeleton-loader v-if="isNil(currentUser)" />
  <v-container v-else>
    <div class="d-flex justify-end mb-3">
      <v-btn
        title="Refresh"
        color="primary"
        append-icon="mdi-sync"
        @click="refresh"
      >
        Sync
      </v-btn>
    </div>

    TODO
  </v-container>
</template>

<script lang="ts" setup>
import { isNil } from "lodash"

import useBreadcrumbs from "@/use/use-breadcrumbs"
import useCurrentUser from "@/use/use-current-user"

const { currentUser, refresh } = useCurrentUser<true>()

useBreadcrumbs("My Profile")
</script>

<style scoped></style>
