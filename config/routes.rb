Rails.application.routes.draw do
  # Przekierowanie devise na domain/login itp -> usuniecie /users/ z linku
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }

  # You can have the root of your site routed with "root"
  root 'trips#index'

  get 'dashboard' => 'trips#dashboard'

  get 'mytrips' => 'trips#mytrips'
  get 'whoami' => 'trips#who_am_i'

  get 'trips/:id', to: 'trips#show'
  post 'trips/by_car_type', to: 'trips#get_trips_by_car_type'
  post 'trips/by_distance', to: 'trips#get_trips_by_distance'

  post 'save_trip', to: 'trips#create'

  post 'challenge/create', to: 'challenges#create'
  get 'challenge/all', to: 'challenges#all'
  post 'challenge/join', to: 'challenges#join'
  get 'challenge/path/:id', to: 'challenges#show_path'
  post 'challenge/trips', to: 'challenges#get_challenge_trips'
  post 'challenge/users', to: 'challenges#get_all_users'
  post 'challenge/invite', to: 'challenges#invite_user'

  namespace :android do
    devise_scope :user do
      post 'registration' => 'registrations#create', :as => 'register'
      post 'login' => 'sessions#create', :as => 'login'
      delete 'logout' => 'sessions#destroy', :as => 'logout'
      post 'update_car_type' => 'users#update_car_type'
      post 'get_gear_params' => 'users#get_gear_params'
    end
  end
end
