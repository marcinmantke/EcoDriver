# encoding: UTF-8
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

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
 
  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
 
private
  def extract_locale_from_accept_language_header
    acceptance_language = ['pl', 'en']
    unless request.env['HTTP_ACCEPT_LANGUAGE'] == nil
      lang = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      if acceptance_language.include? lang
        lang
      else
        I18n.default_locale
      end
    end
  end

  def default_url_options(options = {})
  { locale: I18n.locale }.merge options
  end
end
