<template>
  <h2 class="mb-3">Solid FM Accounting</h2>
  <v-row>
    <v-col
      cols="12"
      md="8"
    >
      <v-card class="border">
        <v-card-text>
          <p class="text-subtitle-1 mb-4">This application provides ...</p>

          <v-row>
            <v-col cols="12"> TODO </v-col>
          </v-row>

          <v-row>
            <v-col>
              <p>
                <router-link
                  :to="{
                    name: 'archive-items/ArchiveItemListPage',
                  }"
                  >View the Knowledge Items</router-link
                >
              </p>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>
    </v-col>
    <v-col> TODO </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import useBreadcrumbs from "@/use/use-breadcrumbs"

useBreadcrumbs("Solid FM Accounting Home", [])
</script>

<style>
.v-card-item__prepend i {
  color: #7a7878;
}
</style>
