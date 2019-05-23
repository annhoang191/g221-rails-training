Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:create]
      post "/auth/login", to: "authentication#login"
      resources :notes, only: %i[index create update destroy]
    end
  end
end
