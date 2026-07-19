export type ValidationErrors = Record<string, string[]>

export class ApiError extends Error {
  public readonly name = "ApiError"

  constructor(
    message: string,
    public readonly status: number,
    public readonly errors: ValidationErrors = {}
  ) {
    super(message)
  }
}

export default ApiError
