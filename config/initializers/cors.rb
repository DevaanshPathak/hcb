# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  domains = %w{https://hackclub.com localhost}.freeze

  allow do
    origins "https://hackclub.com", "https://bank.engineering", "https://hcb-engr.hackclub.dev"

    resource "/api/current_user",
             credentials: true
  end

  allow do
    origins do |source, _env|
      if source.present?
        parsed = URI.parse(source)
        domains.any? { |domain| domain == source || domain == parsed.host }
      else
        false
      end
    rescue URI::InvalidURIError
      false
    end

    resource "/api/*",
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: ["X-Next-Page", "X-Offset", "X-Page", "X-Per-Page", "X-Prev-Page", "X-Request-Id", "X-Runtime", "X-Total", "X-Total-Pages"]

    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
