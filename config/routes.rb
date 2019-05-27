Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/auth/login", to: "authentication#login"
      get "/auth/:provider/callback", to: "authentication#oauth2"
    end
  end
end
