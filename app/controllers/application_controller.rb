# encoding: UTF-8
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    '/#/dashboard'
  end

  def after_sign_up_path_for(_resource)
    '/#/dashboard'
  end

  def after_sign_out_path_for(_resource)
    '/'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username,
               :email,
               :password,
               :password_confirmation,
               :remember_me)
    end
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login,
               :username,
               :email,
               :password,
               :remember_me)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username,
               :email,
               :password,
               :password_confirmation,
               :current_password)
    end
  end
  layout :layout_by_resource

  def layout_by_resource
    if user_signed_in?
      'application'
    else
      'login'
    end
  end
end
