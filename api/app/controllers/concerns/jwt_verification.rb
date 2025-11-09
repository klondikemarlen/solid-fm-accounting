# frozen_string_literal: true

require "net/http"
require "uri"

module JwtVerification
  extend ActiveSupport::Concern

  JWKS_CACHE_KEY = "auth0_jwks"
  JWKS_CACHE_TTL = 1.hour

  private

  def decode_token_from_request
    token = extract_token_from_header
    return nil unless token

    decode_jwt(token)
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    Rails.logger.error("JWT verification failed: #{e.message}")
    nil
  end

  def extract_token_from_header
    authorization_header = request.headers["Authorization"]
    return nil unless authorization_header

    authorization_header.split(" ").last
  end

  def decode_jwt(token)
    jwks = fetch_jwks_cached
    JWT.decode(
      token,
      nil,
      true,
      {
        algorithm: "RS256",
        iss: Rails.application.config.auth0.domain + "/",
        aud: Rails.application.config.auth0.audience,
        verify_iss: true,
        verify_aud: true,
        jwks: jwks
      }
    ).first
  end

  def fetch_jwks_cached
    cached_jwks = Rails.cache.read(JWKS_CACHE_KEY)
    return cached_jwks if cached_jwks

    jwks = fetch_jwks_from_auth0
    Rails.cache.write(JWKS_CACHE_KEY, jwks, expires_in: JWKS_CACHE_TTL)
    jwks
  rescue StandardError => e
    Rails.logger.error("Failed to fetch JWKS: #{e.message}")
  end

  def fetch_jwks_from_auth0
    jwks_uri = URI("#{Rails.application.config.auth0.domain}/.well-known/jwks.json")
    response = Net::HTTP.get_response(jwks_uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise "Failed to fetch JWKS: HTTP #{response.code}"
    end

    JSON.parse(response.body, symbolize_names: true)
  end
end
