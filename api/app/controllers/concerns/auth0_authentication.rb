# frozen_string_literal: true

module Auth0Authentication
  extend ActiveSupport::Concern

  include JwtVerification

  included do
    attr_reader :current_user
  end

  private

  def authenticate_user!
    decoded_token = decode_token_from_request
    return unauthorized unless decoded_token

    @current_user = find_or_create_user_from_token(decoded_token)
    unauthorized unless @current_user
  end

  def find_or_create_user_from_token(decoded_token)
    auth0_subject = decoded_token["sub"]
    email = decoded_token["email"]
    name = decoded_token["name"]

    user = User.find_by(auth0_subject: auth0_subject)
    return user if user

    create_user_from_token(auth0_subject, email, name)
  end

  def create_user_from_token(auth0_subject, email, name)
    name_parts = name&.split(" ") || []
    first_name = name_parts.first || email&.split("@")&.first || "Unknown"
    last_name = name_parts[1..].join(" ").presence

    User.create!(
      auth0_subject: auth0_subject,
      email: email,
      first_name: first_name,
      last_name: last_name,
      display_name: name || email || "Unknown User"
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to create user: #{e.message}")
    nil
  end

  def unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
