Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :clients, only: %i[create show]

      resources :tracking_links, only: %i[index create show], param: :tracking_code do
        member do
          get :redirect
          get :tracking_data
        end
      end
    end
  end

  get '/:tracking_code', to: 'links#redirect'
end
