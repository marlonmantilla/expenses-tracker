Rails.application.routes.draw do
  
  devise_for :users
  resources :expenses

  root 'expenses#index'

  namespace :api do
	  namespace :v1 do
	  	resources :expenses
	  end
	end

end
