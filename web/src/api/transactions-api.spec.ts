import { beforeEach, describe, expect, it, vi } from "vitest"

import http from "@/api/http-client"
import { transactionsApi } from "@/api/transactions-api"
import type { TransactionInput } from "@/api/transactions-api"

vi.mock("@/api/http-client", () => ({
  default: {
    patch: vi.fn(),
    post: vi.fn(),
  },
}))

const attributes: TransactionInput = {
  accountId: 1,
  amount: "12.34",
  categoryId: 2,
  description: "Printer paper",
  paymentMethodId: 3,
  receipts: [new File(["receipt"], "receipt.pdf", { type: "application/pdf" })],
  transactionDate: "2026-07-19",
  transactionType: "expense",
  vendor: "Office Supply Store",
}

describe("transactionsApi", () => {
  beforeEach(() => {
    vi.mocked(http.post).mockResolvedValue({ data: {} } as never)
  })

  it("sends receipts as multipart transaction attributes", async () => {
    await transactionsApi.create(attributes)

    const [url, formData, config] = vi.mocked(http.post).mock.calls[0]

    expect(url).toBe("/api/transactions")
    expect(formData).toBeInstanceOf(FormData)
    expect((formData as FormData).get("transaction[account_id]")).toBe("1")
    expect((formData as FormData).get("transaction[transaction_type]")).toBe("expense")
    expect((formData as FormData).get("transaction[receipts][]")).toBe(attributes.receipts[0])
    expect(config).toEqual({ headers: { "Content-Type": "multipart/form-data" } })
  })
})
