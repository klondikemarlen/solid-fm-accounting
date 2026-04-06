<template>
  <h2 class="mb-3">Solid FM Accounting</h2>
  <v-row>
    <v-col
      cols="12"
      md="8"
    >
      <v-card class="border">
        <v-card-text>
          <p class="text-subtitle-1 mb-4">Welcome to Solid FM Accounting.</p>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import useBreadcrumbs from "@/use/use-breadcrumbs"

useBreadcrumbs("Solid FM Accounting Home", [])
</script>
