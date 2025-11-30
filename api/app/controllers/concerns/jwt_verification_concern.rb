# frozen_string_literal: true

require "jwt"

require "net/http"
require "uri"

module JwtVerificationConcern
  extend ActiveSupport::Concern

  JWKS_CACHE_KEY = "auth0_public_jwks"
  JWKS_CACHE_TTL = 1.hour

  private

  def decode_authorization_token
    return nil unless authorization_token

    decode_auth0_authorization_token(authorization_token)
  rescue JWT::DecodeError, JWT::ExpiredSignature => error
    Rails.logger.error("JWT verification failed: #{error}")
    nil
  end

  def authorization_token
    @authorization_token ||= begin
      authorization_header = request.headers["Authorization"]

      return nil unless authorization_header.present?
      authorization_header.split(" ").last
    end
  end

  def decode_auth0_authorization_token(token)
    return nil unless auth0_public_jwks.present?

    iss = "#{Rails.application.config.auth0.domain}/"

    JWT.decode(
      token,
      nil,
      true,
      {
        algorithms: ["RS256"],
        iss:,
        verify_iss: true,
        aud: Rails.application.config.auth0.audience,
        verify_aud: true,
        jwks: auth0_public_jwks
      }
    ).first
  end

  def auth0_public_jwks
    @auth0_public_jwks ||= begin
      Rails.cache.fetch(JWKS_CACHE_KEY, expires_in: JWKS_CACHE_TTL) do
        jwks_uri = URI("#{Rails.application.config.auth0.domain}/.well-known/jwks.json")
        response = Net::HTTP.get_response(jwks_uri)

        unless response.is_a?(Net::HTTPSuccess)
          raise "Failed to fetch JWKS from Auth0: HTTP #{response.code}"
        end

        parsed_response = JSON.parse(response.body)
        JWT::JWK::Set.new(parsed_response)
      end
    rescue StandardError => error
      Rails.logger.error("Failed to fetch JWKS from Auth0: #{error}")

      nil
    end
  end
end
