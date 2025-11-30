# frozen_string_literal: true

# export async function autheticateAndLoadUser(req: Request, res: Response, next: NextFunction) {
#   if (isAuthenticatedRequest(req)) {
#     console.warn(
#       'Already authenticated, "autheticateAndLoadUser" not have been called a second time'
#     )
#     return next()
#   }

#   // eslint-disable-next-line @typescript-eslint/ban-ts-comment
#   // @ts-ignore I can't figure out how to override express-jwt's req.user type definition
#   const { sub } = req.user
#   if (!isNil(sub)) {
#     req.user = (await User.findOne({ where: { sub } })) || req.user
#     if (isAuthenticatedRequest(req)) {
#       return next()
#     }
#   }

#   const token = req.headers.authorization
#   if (isNil(token)) {
#     return res.status(401).json({ error: "No token provided" })
#   }

#   return auth0Integration
#     .getUserInfo(token)
#     .then(async ({ sub, email, firstName, lastName }) => {
#       // eslint-disable-next-line @typescript-eslint/ban-ts-comment
#       // @ts-ignore I can't figure out how to override express-jwt's req.user type definition
#       req.user = await User.findOne({ where: { sub } })

#       if (isNil(req.user)) {
#         // eslint-disable-next-line @typescript-eslint/ban-ts-comment
#         // @ts-ignore I can't figure out how to override express-jwt's req.user type definition
#         req.user = await User.findOne({ where: { email } })
#         if (!isNil(req.user)) {
#           // eslint-disable-next-line @typescript-eslint/ban-ts-comment
#           // @ts-ignore I can't figure out how to override express-jwt's req.user type definition
#           req.user.update({ sub, firstName, lastName })
#         }
#       }

#       if (isNil(req.user)) {
#         req.user = await User.create({
#           email,
#           sub,
#           status: UserStatus.ACTIVE,
#           firstName,
#           lastName,
#         })
#       }

#       if (!isAuthenticatedRequest(req)) {
#         throw new Error("Failed to authenticate user")
#       }

#       return next()
#     })
#     .catch((error) => {
#       return res.status(401).json({ message: `Failed to get user info: ${error}` })
#     })
# }

module Auth0AuthenticationConcern
  extend ActiveSupport::Concern

  include JwtVerificationConcern

  included do
    attr_reader :current_user
  end

  private

  def authenticate_user!
    decoded_token = decode_authorization_token
    unless decoded_token
      Rails.logger.error("No authorization token provided")
      render json: { message: "No authorization token provided" }, status: :unauthorized
      return
    end

    @current_user = find_or_create_user_from_token(decoded_token)
    unless @current_user
      Rails.logger.error("Failed to authenticate user")
      render json: { message: "Failed to authenticate user" }, status: :unauthorized
      return
    end
  rescue StandardError => error
    Rails.logger.error("Authentication error: #{error}")
    render json: { message: "Authentication failed" }, status: :unauthorized
    return
  end

  def find_or_create_user_from_token(decoded_token)
    puts "decoded_token: #{decoded_token}"
    # Token format is not what I would expect? Maybe I'm sending the wrong type of data?
    # Or I'm not retrieving the correct data from Auth0?
    # {"iss" => "https://solid-fm-accounting.ca.auth0.com/", "sub" => "tV9Mf8FNHtUrWZhhtbWv7PaN9nnkg68f@clients", "aud" => "http://localhost:3000/api", "iat" => 1762726657, "exp" => 1762813057, "gty" => "client-credentials", "azp" => "tV9Mf8FNHtUrWZhhtbWv7PaN9nnkg68f"}
    # I think after I decode the token I need to retrieve the user data from Auth0 like how api/src/integrations/auth0-integration.ts does it in WRAP
    user_info = Integrations::Auth0Integration.get_user_info(decoded_token)
    auth0_subject = decoded_token["sub"]
    user = User.find_by(auth0_subject: auth0_subject)
    return user if user

    # need to retrieve user from auth0 before I can get email and name
    create_user_from_token(auth0_subject, email, name)
  end

  def create_user_from_token(auth0_subject, email, name)
    name_parts = name&.split(" ") || []
    first_name = name_parts.first || email&.split("@")&.first || "Unknown"
    last_name = name_parts[1..]&.join(" ")&.presence

    User.create!(
      auth0_subject: auth0_subject,
      email: email,
      first_name: first_name,
      last_name: last_name,
      display_name: name || email || "Unknown User"
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to create user: #{e.message}")
    unauthorizednil
  end

  def unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
