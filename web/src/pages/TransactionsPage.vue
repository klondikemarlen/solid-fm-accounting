<template>
  <div class="d-flex flex-wrap align-center justify-space-between mb-4 ga-3">
    <h2>Transactions</h2>
    <v-btn
      color="primary"
      prepend-icon="mdi-plus"
      @click="openNewTransaction"
    >
      Add Transaction
    </v-btn>
  </div>

  <v-progress-linear
    v-if="isLoading"
    color="primary"
    indeterminate
  />

  <v-alert
    v-else-if="errorMessage"
    title="Transactions could not be loaded"
    type="error"
  >
    {{ errorMessage }}
    <template #append>
      <v-btn
        variant="text"
        @click="loadTransactions"
      >
        Try again
      </v-btn>
    </template>
  </v-alert>

  <v-card v-else-if="accounts.length === 0">
    <v-card-title>Set up an account first</v-card-title>
    <v-card-text>
      Add the cash, bank, savings, or credit-card account used for your business transactions.
    </v-card-text>
    <v-card-actions>
      <v-btn
        color="primary"
        variant="flat"
        @click="showAccountSetup = true"
      >
        Add Account
      </v-btn>
    </v-card-actions>
  </v-card>

  <v-card v-else-if="transactions.length === 0">
    <v-card-title>No transactions yet</v-card-title>
    <v-card-text>Record your first income or expense to start your ledger.</v-card-text>
  </v-card>

  <section
    v-for="group in transactionGroups"
    v-else
    :key="group.date"
    class="mb-6"
  >
    <h3 class="text-h6 mb-2">{{ formatDate(group.date) }}</h3>
    <v-card>
      <v-table>
        <thead>
          <tr>
            <th>Type</th>
            <th>Vendor</th>
            <th>Category</th>
            <th>Account</th>
            <th class="text-right">Amount</th>
            <th>Receipts</th>
            <th><span class="sr-only">Actions</span></th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="transaction in group.transactions"
            :key="transaction.id"
          >
            <td>
              <v-chip
                :color="transaction.transactionType === 'income' ? 'success' : 'warning'"
                size="small"
              >
                {{ transaction.transactionType }}
              </v-chip>
            </td>
            <td>{{ transaction.vendor || "—" }}</td>
            <td>{{ transaction.category.name }}</td>
            <td>{{ transaction.account.name }}</td>
            <td
              :class="transaction.transactionType === 'income' ? 'text-success' : 'text-warning'"
              class="text-right text-no-wrap"
            >
              {{ formatAmount(transaction) }}
            </td>
            <td>{{ receiptState(transaction) }}</td>
            <td class="text-right text-no-wrap">
              <v-btn
                :aria-label="`Edit ${transaction.vendor || 'transaction'}`"
                icon="mdi-pencil"
                size="small"
                variant="text"
                @click="openEditTransaction(transaction)"
              />
              <v-btn
                :aria-label="`Delete ${transaction.vendor || 'transaction'}`"
                color="error"
                icon="mdi-delete"
                size="small"
                variant="text"
                @click="deleteTransaction(transaction)"
              />
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-card>
  </section>

  <TransactionFormDialog
    v-model="showTransactionForm"
    :accounts="accounts"
    :categories="categories"
    :payment-methods="paymentMethods"
    :transaction="selectedTransaction"
    @saved="transactionSaved"
  />
  <AccountSetupDialog
    v-model="showAccountSetup"
    @created="accountCreated"
  />
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from "vue"

import accountsApi from "@/api/accounts-api"
import ApiError from "@/api/api-error"
import { transactionReferenceApi, transactionsApi } from "@/api/transactions-api"
import type { Account, Category, PaymentMethod, Transaction } from "@/api/transactions-api"
import AccountSetupDialog from "@/components/transactions/AccountSetupDialog.vue"
import TransactionFormDialog from "@/components/transactions/TransactionFormDialog.vue"
import useBreadcrumbs from "@/use/use-breadcrumbs"
import useSnack from "@/use/use-snack"

useBreadcrumbs("Transactions", [])

const accounts = ref<Account[]>([])
const categories = ref<Category[]>([])
const errorMessage = ref("")
const isLoading = ref(true)
const paymentMethods = ref<PaymentMethod[]>([])
const selectedTransaction = ref<Transaction | null>(null)
const showAccountSetup = ref(false)
const showTransactionForm = ref(false)
const transactions = ref<Transaction[]>([])
const snack = useSnack()

const transactionGroups = computed(() => {
  const groups = new Map<string, Transaction[]>()

  for (const transaction of transactions.value) {
    groups.set(transaction.transactionDate, [...(groups.get(transaction.transactionDate) || []), transaction])
  }

  return Array.from(groups, ([date, transactions]) => ({ date, transactions }))
})

onMounted(loadTransactions)

async function loadTransactions() {
  errorMessage.value = ""
  isLoading.value = true

  try {
    const [loadedTransactions, loadedAccounts, loadedCategories, loadedPaymentMethods] = await Promise.all([
      transactionsApi.list(),
      accountsApi.list(),
      transactionReferenceApi.listCategories(),
      transactionReferenceApi.listPaymentMethods(),
    ])
    transactions.value = loadedTransactions
    accounts.value = loadedAccounts
    categories.value = loadedCategories
    paymentMethods.value = loadedPaymentMethods
  } catch (error) {
    errorMessage.value = error instanceof ApiError ? error.message : "Please try again"
  } finally {
    isLoading.value = false
  }
}

function openNewTransaction() {
  if (accounts.value.length === 0) {
    showAccountSetup.value = true
    return
  }

  selectedTransaction.value = null
  showTransactionForm.value = true
}

function openEditTransaction(transaction: Transaction) {
  selectedTransaction.value = transaction
  showTransactionForm.value = true
}

function accountCreated(account: Account) {
  accounts.value = [...accounts.value, account].sort((left, right) => left.name.localeCompare(right.name))
  showTransactionForm.value = true
}

function transactionSaved(transaction: Transaction) {
  transactions.value = [
    ...transactions.value.filter((existingTransaction) => existingTransaction.id !== transaction.id),
    transaction,
  ].sort(
    (left, right) =>
      right.transactionDate.localeCompare(left.transactionDate) || right.id - left.id
  )
  snack.success("Transaction saved")
}

async function deleteTransaction(transaction: Transaction) {
  if (!window.confirm(`Delete ${transaction.vendor || "this transaction"}?`)) return

  try {
    await transactionsApi.delete(transaction.id)
    transactions.value = transactions.value.filter(
      (existingTransaction) => existingTransaction.id !== transaction.id
    )
    snack.success("Transaction deleted")
  } catch (error) {
    snack.error(error instanceof ApiError ? error.message : "Unable to delete this transaction")
  }
}

function formatAmount(transaction: Transaction): string {
  const prefix = transaction.transactionType === "income" ? "+" : "−"

  return `${prefix}$${Number(transaction.amount).toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`
}

function formatDate(date: string): string {
  return new Intl.DateTimeFormat(undefined, {
    day: "numeric",
    month: "long",
    weekday: "long",
    year: "numeric",
  }).format(new Date(`${date}T00:00:00`))
}

function receiptState(transaction: Transaction): string {
  const count = transaction.receipts.length

  return count === 0 ? "No receipts" : `${count} receipt${count === 1 ? "" : "s"}`
}
</script>
