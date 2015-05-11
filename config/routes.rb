Rails.application.routes.draw do

   
    # Przekierowanie devise na domain/login itp -> usunięcie /users/ z linku
	devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}


	# You can have the root of your site routed with "root"
	root 'trips#index'

  get 'dashboard' => 'trips#dashboard'

	get 'mytrips' => 'trips#mytrips'
	get 'whoami' => 'trips#WhoAmI'

	get  'trips/:id', to: 'trips#show'
	post 'trips/by_car_type', to: 'trips#getTripsByCarType'
	post 'trips/by_distance', to: 'trips#getTripsByDistance'

  post 'save_trip', to: 'trips#create'

  post 'challenge/create', to: 'challenges#create'
  get 'challenge/all', to: 'challenges#all'
  post 'challenge/join', to: 'challenges#join'
  get  'challenge/path/:id', to: 'challenges#showPath'
  post  'challenge/trips', to: 'challenges#getChallengeTrips'

	namespace :android do
    devise_scope :user do
    	post 'registration' => 'registrations#create', :as => 'register'
    	post 'login' => 'sessions#create', :as => 'login'
    	delete 'logout' => 'sessions#destroy', :as => 'logout'
    	post 'update_car_type' => 'users#updateCarType'
  	end
	end

end 
