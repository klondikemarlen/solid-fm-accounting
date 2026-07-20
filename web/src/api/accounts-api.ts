import http from "@/api/http-client"

import type { Account } from "@/api/transactions-api"

export type AccountInput = Pick<Account, "name" | "accountType">

export const accountsApi = {
  async list(): Promise<Account[]> {
    const { data } = await http.get("/api/accounts")
    return data
  },

  async create(attributes: AccountInput): Promise<Account> {
    const { data } = await http.post("/api/accounts", {
      account: {
        name: attributes.name,
        account_type: attributes.accountType,
      },
    })
    return data
  },
}

export default accountsApi
