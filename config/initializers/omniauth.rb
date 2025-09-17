Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line,
    ENV["LINE_KEY"],
    ENV["LINE_SECRET"],
    scope: "profile openid email",
    callback_url: "https://tomoni.onrender.com/users/auth/line/callback"
end