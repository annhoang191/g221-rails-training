Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:create]
      resources :notes, only: %i[index create update destroy]
      post "/auth/login", to: "authentication#login"
      get "/auth/:provider/callback", to: "authentication#oauth2"
    end
  end
end
