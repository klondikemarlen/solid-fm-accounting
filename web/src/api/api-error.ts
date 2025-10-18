export class ApiError extends Error {
  public readonly name = "ApiError"

  constructor(
    message: string,
    public readonly status: number
  ) {
    super(message)
  }
}

export default ApiError
