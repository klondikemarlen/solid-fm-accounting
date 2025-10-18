import { isNil } from "lodash"

export const integerTransformer = {
  get(value: number | string | null | undefined): number | undefined {
    if (isNil(value)) return undefined
    if (typeof value === "number") return value

    return parseInt(value, 10)
  },
  set(value: number | undefined): string | undefined {
    if (isNil(value)) return undefined

    return String(value)
  },
}

export default integerTransformer
