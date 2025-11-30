# Original TypeScript implementation (for reference):
# import axios from "axios"
# import { isNil } from "lodash"
#
# import { AUTH0_DOMAIN } from "@/config"
#
# const auth0Api = axios.create({
#   baseURL: AUTH0_DOMAIN,
# })
#
# interface Auth0UserInfo {
#   email: string
#   firstName: string
#   lastName: string
#   sub: string
# }
#
# function getUserInfo(token: string): Promise<Auth0UserInfo> {
#   return auth0Api.get("/userinfo", { headers: { authorization: token } }).then(({ data }) => {
#     // TODO: write a type for the auth0 response and assert that the payload conforms to it
#     if (isNil(data.sub)) {
#       // TODO: this might not even be possible?
#       throw new Error("Payload from Auth0 is missing a subject.")
#     }
#     const firstName = data.given_name || "UNKNOWN"
#     const lastName = data.family_name || "UNKNOWN"
#     return {
#       email: data.email || `${firstName}.${lastName}@yukon-no-email.ca`,
#       firstName,
#       lastName,
#       sub: data.sub,
#     }
#   })
# }
#
# export default { getUserInfo }

require "httparty"

module Integrations
  class Auth0Integration
    include HTTParty
    base_uri ENV.fetch("VITE_AUTH0_DOMAIN").chomp("/")

    # Auth0 UserInfo structure
    Auth0UserInfo = Struct.new(:email, :first_name, :last_name, :sub, keyword_init: true)

    # Fetches user information from Auth0 using the provided token
    #
    # @param authorization_token [String] The authorization token (usually "Bearer <jwt>")
    # @return [Auth0UserInfo] The user information from Auth0
    # @raise [StandardError] If the Auth0 response is missing the subject
    def self.get_user_info(authorization_token)
      response = get("/userinfo", headers: { "Authorization" => authorization_token })

      sub, email = response.parsed_response.values_at("sub", "email")

      # TODO: write a type for the auth0 response and assert that the payload conforms to it
      raise StandardError, "Payload from Auth0 is missing a subject." if sub.nil?
      raise StandardError, "Payload from Auth0 is missing a valid email address." if email.blank?

      Auth0UserInfo.new(email:, sub:)
    end
  end
end
