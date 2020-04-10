Rails.application.routes.draw do
  # mount Microservices::API => '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :service_categories, only: [:index, :create, :update]
end
