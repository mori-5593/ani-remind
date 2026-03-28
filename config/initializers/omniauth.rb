Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           {
            scope: "email,profile",
            prompt: "select_account"
           }
  provider :line,
           ENV["LINE_CHANNEL_ID"],
           ENV["LINE_CHANNEL_SECRET"],
           {
            scope: "profile openid email"
           }
end

OmniAuth.config.allowed_request_methods = [ :get, :post ]
