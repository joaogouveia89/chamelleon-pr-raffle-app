Rails.application.routes.draw do
  resources :raffles
  resources :users

  root :to => "raffles#index"

  post "/raffle" => "raffles#raffle", :as => :raffle_action 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
