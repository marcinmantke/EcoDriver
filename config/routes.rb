Rails.application.routes.draw do

   
    # Przekierowanie devise na domain/login itp -> usunięcie /users/ z linku
	devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'register'}
  
	#devise_for :users, controllers: { sessions: "users/sessions" }
	# Przekierowanie v2
	#as :user do
  	#	get "login" => "devise/sessions#new"
  	#	post "login" => "devise/sessions#create"
  	#	post "register" => "devise/registration#new"
  	#	get "logout" => "devise/sessions#destroy"
	#end



	#devise_for :users#, controllers: { sessions: "users/sessions" }, :skip => [:sessions]
  	#as :user do
    #	get '/login' => 'users/sessions#new', :as => :new_user_session
	#	post '/login' => 'users/sessions#create', :as => :user_session
    #	get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  	#end


	# You can have the root of your site routed with "root"
	root 'trips#index'
	get '/mytrips' => "trips#mytrips"
	get '/whoami' => 'trips#WhoAmI'
	get 'logintest' => 'trips#LoginTest'

	resources :trips, only: [:index, :show, :create]
	post 'trips/by_car_type', to: 'trips#getTripsByCarType'
	post 'trips/by_distance', to: 'trips#getTripsByDistance'

end 
