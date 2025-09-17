OmniAuth.config.allowed_request_methods = [ :get, :post ]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line,
    ENV["LINE_KEY"],
    ENV["LINE_SECRET"],
    scope: "profile openid",
    provider_ignores_state: true
end