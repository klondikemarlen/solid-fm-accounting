import { mount } from "@vue/test-utils"
import type { VueWrapper } from "@vue/test-utils"
import { beforeEach, describe, expect, it, vi } from "vitest"

import { transactionsApi } from "@/api/transactions-api"
import type { Transaction } from "@/api/transactions-api"
import TransactionFormDialog from "@/components/transactions/TransactionFormDialog.vue"

vi.mock("@/api/transactions-api", () => ({
  transactionsApi: {
    create: vi.fn(),
    update: vi.fn(),
  },
}))

vi.mock("@/components/common/StringDateInput.vue", () => ({
  default: { template: "<input />" },
}))

const transaction: Transaction = {
  id: 42,
  transactionDate: "2026-07-19",
  transactionType: "expense",
  amount: "12.34",
  vendor: "Office Supply Store",
  description: "Printer paper",
  account: { id: 1, name: "Business Chequing", accountType: "chequing" },
  category: {
    id: 2,
    code: "office-expenses",
    name: "Office Expenses",
    transactionType: "expense",
  },
  paymentMethod: { id: 3, name: "Credit Card" },
  receipts: [],
}

const componentStub = {
  inheritAttrs: false,
  template: "<div><slot /></div>",
}

function formStub(valid: boolean) {
  return {
    template: "<form><slot /></form>",
    methods: {
      validate() {
        return Promise.resolve({ valid })
      },
    },
  }
}

function buttonStub() {
  return {
    inheritAttrs: false,
    template: '<button @click="$emit(\'click\')"><slot /></button>',
  }
}

function mountDialog(valid = true): VueWrapper {
  return mount(TransactionFormDialog, {
    props: {
      accounts: [transaction.account],
      categories: [transaction.category],
      modelValue: true,
      paymentMethods: [transaction.paymentMethod],
      transaction,
    },
    global: {
      stubs: {
        StringDateInput: componentStub,
        VAlert: componentStub,
        VBtn: buttonStub(),
        VCard: componentStub,
        VCardActions: componentStub,
        VCardText: componentStub,
        VCardTitle: componentStub,
        VCol: componentStub,
        VDialog: componentStub,
        VFileInput: componentStub,
        VForm: formStub(valid),
        VRadio: componentStub,
        VRadioGroup: componentStub,
        VRow: componentStub,
        VSelect: componentStub,
        VSpacer: componentStub,
        VTextarea: componentStub,
        VTextField: componentStub,
      },
    },
  })
}

async function save(wrapper: VueWrapper) {
  const button = wrapper.findAll("button").find((button) => button.text() === "Save Transaction")
  await button?.trigger("click")
}

describe("TransactionFormDialog", () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it("saves a valid edited transaction", async () => {
    vi.mocked(transactionsApi.update).mockResolvedValue(transaction)
    const wrapper = mountDialog()

    await save(wrapper)

    expect(transactionsApi.update).toHaveBeenCalledWith(
      transaction.id,
      expect.objectContaining({
        accountId: transaction.account.id,
        categoryId: transaction.category.id,
        paymentMethodId: transaction.paymentMethod.id,
      })
    )
    expect(wrapper.emitted("saved")).toEqual([[transaction]])
  })

  it("does not save when client validation fails", async () => {
    const wrapper = mountDialog(false)

    await save(wrapper)

    expect(transactionsApi.create).not.toHaveBeenCalled()
    expect(transactionsApi.update).not.toHaveBeenCalled()
  })
})
