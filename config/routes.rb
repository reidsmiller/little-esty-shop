Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/merchants/:id/dashboard", to: 'merchant/dashboards#show'
  
  resources :merchants, except: [:index, :show, :edit, :destroy, :new, :create, :update]  do
    resources :items, only: [:index, :show], controller: "merchant/items"
    resources :invoices, only: [:index, :show], controller: "merchant/invoices"
  end
end
