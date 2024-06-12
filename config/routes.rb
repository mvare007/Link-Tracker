Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :clients, only: %i[create show]

      resources :tracking_links, only: %i[index show] do
        member do
          get :redirect
          get :stats
        end
      end
    end
  end
end
