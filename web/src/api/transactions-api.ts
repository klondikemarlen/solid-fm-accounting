import http from "@/api/http-client"

export type TransactionType = "income" | "expense"

export type Account = {
  id: number
  name: string
  accountType: "cash" | "chequing" | "savings" | "credit_card"
}

export type Category = {
  id: number
  code: string
  name: string
  transactionType: TransactionType | "both"
}

export type PaymentMethod = {
  id: number
  name: string
}

export type Receipt = {
  id: number
  filename: string
  contentType: string
  byteSize: number
}

export type Transaction = {
  id: number
  transactionDate: string
  transactionType: TransactionType
  amount: string
  vendor: string | null
  description: string | null
  account: Account
  category: Category
  paymentMethod: PaymentMethod
  receipts: Receipt[]
}

export type TransactionInput = {
  accountId: number
  amount: string
  categoryId: number
  description: string
  paymentMethodId: number
  receipts: File[]
  transactionDate: string
  transactionType: TransactionType
  vendor: string
}

function transactionFormData(attributes: TransactionInput) {
  const formData = new FormData()
  const values = {
    account_id: attributes.accountId,
    amount: attributes.amount,
    category_id: attributes.categoryId,
    description: attributes.description,
    payment_method_id: attributes.paymentMethodId,
    transaction_date: attributes.transactionDate,
    transaction_type: attributes.transactionType,
    vendor: attributes.vendor,
  }

  for (const [name, value] of Object.entries(values)) {
    formData.append(`transaction[${name}]`, String(value))
  }

  for (const receipt of attributes.receipts) {
    formData.append("transaction[receipts][]", receipt)
  }

  return formData
}

export const transactionsApi = {
  async list(): Promise<Transaction[]> {
    const { data } = await http.get("/api/transactions")
    return data
  },

  async create(attributes: TransactionInput): Promise<Transaction> {
    const { data } = await http.post("/api/transactions", transactionFormData(attributes), {
      headers: { "Content-Type": "multipart/form-data" },
    })
    return data
  },

  async update(transactionId: number, attributes: TransactionInput): Promise<Transaction> {
    const { data } = await http.patch(
      `/api/transactions/${transactionId}`,
      transactionFormData(attributes),
      { headers: { "Content-Type": "multipart/form-data" } }
    )
    return data
  },

  async delete(transactionId: number): Promise<void> {
    await http.delete(`/api/transactions/${transactionId}`)
  },
}

export const transactionReferenceApi = {
  async listCategories(): Promise<Category[]> {
    const { data } = await http.get("/api/categories")
    return data
  },

  async listPaymentMethods(): Promise<PaymentMethod[]> {
    const { data } = await http.get("/api/payment-methods")
    return data
  },
}

export default transactionsApi
