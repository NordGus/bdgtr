Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "bdgtr#root"

  get :finances, controller: :finances, action: :show, as: :finances

  namespace :finances do
    resources :accounts, only: %i[index show new create update destroy], defaults: { format: :turbo_stream }
  end
end
