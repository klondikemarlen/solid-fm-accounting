import qs from "qs"
import axios from "axios"

import { API_BASE_URL } from "@/config"
import auth0 from "@/plugins/auth0-plugin"
import ApiError from "@/api/api-error"


export const httpClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
  paramsSerializer: {
    serialize: (params) => {
      return qs.stringify(params, {
        arrayFormat: "indices",
        strictNullHandling: true,
      })
    },
  },
  formSerializer: {
    indexes: true, // array indexes format null - no brackets, false - empty brackets, true - brackets with indexes
  },
})

httpClient.interceptors.request.use(async (config) => {
  // Only add the Authorization header to requests that start with "/api"
  if (config.url?.startsWith("/api")) {
    const accessToken = await auth0.getAccessTokenSilently()
    config.headers["Authorization"] = `Bearer ${accessToken}`
  }

  return config
})

// Any status codes that falls outside the range of 2xx causes this function to trigger
function validationErrorMessage(errors: Record<string, string[]>): string {
  return Object.entries(errors)
    .flatMap(([attribute, messages]) =>
      messages.map((message) => `${attribute.replace(/([A-Z])/g, " $1")}: ${message}`)
    )
    .join(", ")
}

httpClient.interceptors.response.use(null, async (error) => {
  const status = error?.response?.status || 500
  const errors = error?.response?.data?.errors as Record<string, string[]> | undefined

  if (error?.error === "login_required") {
    throw new ApiError("You must be logged in to access this endpoint", 401)
  } else if (errors && Object.keys(errors).length > 0) {
    throw new ApiError(validationErrorMessage(errors), status, errors)
  } else if (error?.response?.data?.message) {
    throw new ApiError(error.response.data.message, status)
  } else if (error.message) {
    throw new ApiError(error.message, status)
  } else {
    throw new ApiError("An unknown error occurred", status)
  }
})

export default httpClient
