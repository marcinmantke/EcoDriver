Rails.application.routes.draw do
  # Przekierowanie devise na domain/login itp -> usuniecie /users/ z linku
  devise_for :users, path: '',
                     path_names: { sign_in: 'login', sign_out: 'logout' }

  # You can have the root of your site routed with "root"
  root 'trips#index'

  get 'dashboard' => 'trips#dashboard'
  get 'mytrips' => 'trips#mytrips'
  get 'whoami' => 'trips#who_am_i'
  get 'trips/:id', to: 'trips#show'
  post 'trips/ranking', to: 'trips#ranking'
  post 'save_trip', to: 'trips#create'
  post 'economic_ranges', to: 'trips#economic_ranges'

  post 'challenge/create', to: 'challenges#create'
  get 'challenge/all', to: 'challenges#all'
  post 'challenge/join', to: 'challenges#join'
  get 'challenge/path/:id', to: 'challenges#show_path'
  post 'challenge/trips', to: 'challenges#all_challenge_trips'
  post 'challenge/users', to: 'challenges#all_users'
  post 'challenge/invite', to: 'challenges#invite_user'
  get 'challenge/invitations', to: 'challenges#all_invitations'
  post 'challenge/accept_invitation', to: 'challenges#accept_invitation'
  post 'challenge/reject_invitation', to: 'challenges#reject_invitation'

  namespace :android do
    devise_scope :user do
      post 'registration' => 'registrations#create', :as => 'register'
      post 'login' => 'sessions#create', :as => 'login'
      delete 'logout' => 'sessions#destroy', :as => 'logout'
      post 'update_car_type' => 'users#update_car_type'
      post 'get_gear_params' => 'users#gear_params'
      get 'engine_params' => 'users#engine_params'
    end
  end
end
