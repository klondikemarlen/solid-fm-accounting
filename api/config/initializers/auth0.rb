Rails.application.config.auth0 = ActiveSupport::OrderedOptions.new
Rails.application.config.auth0.domain = ENV.fetch("VITE_AUTH0_DOMAIN").chomp("/")
Rails.application.config.auth0.audience = ENV.fetch("VITE_AUTH0_AUDIENCE")
