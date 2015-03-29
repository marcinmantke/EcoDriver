Rails.application.routes.draw do

   
    # Przekierowanie devise na domain/login itp -> usunięcie /users/ z linku
	devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'register'}
  
	# You can have the root of your site routed with "root"
	root 'trips#index'
	resources :trips, only: [:index, :show, :create]
	post 'trips/by_car_type', to: 'trips#getTripsByCarType'

end
