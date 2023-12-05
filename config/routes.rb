Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "bdgtr#root"

  get :finances, controller: :finances, action: :applet, as: :finances

  namespace :finances do
    resources :accounts, only: %i[index show new create update destroy], defaults: { format: :turbo_stream }
  end

  get :balance, controller: :balance, action: :applet, as: :balance

  namespace :balance do
  end
end
