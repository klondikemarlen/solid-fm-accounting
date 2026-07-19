<template>
  <v-dialog
    v-model="open"
    max-width="480"
  >
    <v-card>
      <v-card-title>Add Account</v-card-title>
      <v-card-text>
        <p class="mb-4">Add the account you use to pay for or receive this transaction.</p>
        <v-alert
          v-if="errorMessage"
          class="mb-4"
          type="error"
        >
          {{ errorMessage }}
        </v-alert>
        <v-form ref="form">
          <v-text-field
            v-model="name"
            :rules="[required]"
            label="Account name"
          />
          <v-select
            v-model="accountType"
            :items="accountTypes"
            :rules="[required]"
            item-title="title"
            item-value="value"
            label="Account type"
          />
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn @click="open = false">Cancel</v-btn>
        <v-btn
          :loading="isSaving"
          color="primary"
          variant="flat"
          @click="save"
        >
          Add Account
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from "vue"

import accountsApi from "@/api/accounts-api"
import ApiError from "@/api/api-error"
import type { AccountInput } from "@/api/accounts-api"
import type { Account } from "@/api/transactions-api"

const emit = defineEmits<{
  created: [account: Account]
}>()

const open = defineModel<boolean>({ default: false })
const accountTypes: { title: string; value: AccountInput["accountType"] }[] = [
  { title: "Cash", value: "cash" },
  { title: "Chequing", value: "chequing" },
  { title: "Savings", value: "savings" },
  { title: "Credit card", value: "credit_card" },
]

const form = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)
const accountType = ref<AccountInput["accountType"] | null>(null)
const errorMessage = ref("")
const isSaving = ref(false)
const name = ref("")

watch(open, (isOpen) => {
  if (!isOpen) return

  accountType.value = null
  errorMessage.value = ""
  name.value = ""
})

function required(value: unknown): true | string {
  return (value !== null && value !== undefined && value !== "") || "Required"
}

async function save() {
  errorMessage.value = ""
  const { valid } = (await form.value?.validate()) || { valid: false }
  if (!valid || accountType.value === null) return

  isSaving.value = true

  try {
    const account = await accountsApi.create({ name: name.value, accountType: accountType.value })
    emit("created", account)
    open.value = false
  } catch (error) {
    errorMessage.value = error instanceof ApiError ? error.message : "Unable to add this account"
  } finally {
    isSaving.value = false
  }
}
</script>
