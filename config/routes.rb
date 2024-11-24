Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: [ :index, :create ] do
        resources :sleep_records do
          collection do
            post :clock_in
            post :clock_out
            get :following
          end
        end

        resources :follows, only: [ :create, :destroy ], param: :followed_id
      end
    end
  end
end
