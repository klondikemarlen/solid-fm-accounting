<template>
  <v-dialog
    v-model="open"
    max-width="720"
  >
    <v-card>
      <v-card-title>{{ transaction ? "Edit Transaction" : "Add Transaction" }}</v-card-title>
      <v-card-text>
        <v-alert
          v-if="errorMessage"
          class="mb-4"
          type="error"
        >
          {{ errorMessage }}
        </v-alert>

        <v-form ref="form">
          <v-radio-group
            v-model="values.transactionType"
            :rules="[required]"
            inline
            label="Transaction type"
          >
            <v-radio
              label="Income"
              value="income"
            />
            <v-radio
              label="Expense"
              value="expense"
            />
          </v-radio-group>

          <v-row>
            <v-col
              cols="12"
              sm="6"
            >
              <StringDateInput
                v-model="values.transactionDate"
                :rules="[required]"
                label="Date"
              />
            </v-col>
            <v-col
              cols="12"
              sm="6"
            >
              <v-text-field
                v-model="values.amount"
                :rules="[positiveAmount]"
                label="Amount"
                prefix="$"
                inputmode="decimal"
              />
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
              sm="6"
            >
              <v-select
                v-model="values.categoryId"
                :items="availableCategories"
                :rules="[required]"
                item-title="name"
                item-value="id"
                label="Category"
              />
            </v-col>
            <v-col
              cols="12"
              sm="6"
            >
              <v-select
                v-model="values.paymentMethodId"
                :items="paymentMethods"
                :rules="[required]"
                item-title="name"
                item-value="id"
                label="Payment method"
              />
            </v-col>
          </v-row>

          <v-select
            v-model="values.accountId"
            :items="accounts"
            :rules="[required]"
            item-title="name"
            item-value="id"
            label="Account"
          />
          <v-text-field
            v-model="values.vendor"
            label="Vendor"
          />
          <v-textarea
            v-model="values.description"
            label="Notes"
          />
          <v-file-input
            v-model="values.receipts"
            accept="image/*,application/pdf"
            label="Receipts"
            multiple
            prepend-icon="mdi-paperclip"
          />
          <p
            v-if="transaction?.receipts.length"
            class="text-body-2 text-medium-emphasis"
          >
            {{ transaction.receipts.length }} existing receipt{{ transaction.receipts.length === 1 ? "" : "s" }}
            will remain attached.
          </p>
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
          Save Transaction
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { computed, ref, watch } from "vue"

import ApiError from "@/api/api-error"
import { transactionsApi } from "@/api/transactions-api"
import type {
  Account,
  Category,
  PaymentMethod,
  Transaction,
  TransactionInput,
} from "@/api/transactions-api"
import StringDateInput from "@/components/common/StringDateInput.vue"

const props = defineProps<{
  accounts: Account[]
  categories: Category[]
  paymentMethods: PaymentMethod[]
  transaction: Transaction | null
}>()

const emit = defineEmits<{
  saved: [transaction: Transaction]
}>()

const open = defineModel<boolean>({ default: false })

const form = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)
const errorMessage = ref("")
const isSaving = ref(false)

type TransactionDraft = Omit<TransactionInput, "accountId" | "categoryId" | "paymentMethodId"> & {
  accountId: number | null
  categoryId: number | null
  paymentMethodId: number | null
}

const values = ref<TransactionDraft>(newTransaction())

const availableCategories = computed(() =>
  props.categories.filter(
    (category) =>
      category.transactionType === "both" || category.transactionType === values.value.transactionType
  )
)

watch(
  () => [open.value, props.transaction] as const,
  ([isOpen]) => {
    if (!isOpen) return

    errorMessage.value = ""
    values.value = props.transaction ? transactionDraft(props.transaction) : newTransaction()
  },
  { immediate: true }
)

watch(
  () => values.value.transactionType,
  () => {
    if (!availableCategories.value.some((category) => category.id === values.value.categoryId)) {
      values.value.categoryId = null
    }
  }
)

function newTransaction(): TransactionDraft {
  return {
    accountId: null,
    amount: "",
    categoryId: null,
    description: "",
    paymentMethodId: null,
    receipts: [],
    transactionDate: new Date().toISOString().slice(0, 10),
    transactionType: "expense",
    vendor: "",
  }
}

function transactionDraft(transaction: Transaction): TransactionDraft {
  return {
    accountId: transaction.account.id,
    amount: transaction.amount,
    categoryId: transaction.category.id,
    description: transaction.description || "",
    paymentMethodId: transaction.paymentMethod.id,
    receipts: [],
    transactionDate: transaction.transactionDate,
    transactionType: transaction.transactionType,
    vendor: transaction.vendor || "",
  }
}

function required(value: unknown): true | string {
  return value !== null && value !== undefined && value !== "" || "Required"
}

function positiveAmount(value: unknown): true | string {
  return Number(value) > 0 || "Enter an amount greater than zero"
}

async function save() {
  errorMessage.value = ""
  const { valid } = (await form.value?.validate()) || { valid: false }
  if (!valid || values.value.accountId === null || values.value.categoryId === null || values.value.paymentMethodId === null) {
    return
  }

  isSaving.value = true

  try {
    const attributes: TransactionInput = {
      ...values.value,
      accountId: values.value.accountId,
      categoryId: values.value.categoryId,
      paymentMethodId: values.value.paymentMethodId,
    }
    const transaction = props.transaction
      ? await transactionsApi.update(props.transaction.id, attributes)
      : await transactionsApi.create(attributes)

    emit("saved", transaction)
    open.value = false
  } catch (error) {
    errorMessage.value = error instanceof ApiError ? error.message : "Unable to save this transaction"
  } finally {
    isSaving.value = false
  }
}
</script>
