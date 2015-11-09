class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include StudysessionsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) << :nickname
      devise_parameter_sanitizer.for(:sign_up) << :nickname
      devise_parameter_sanitizer.for(:account_update) << :nickname
      devise_parameter_sanitizer.for(:account_update) << :word
      devise_parameter_sanitizer.for(:account_update) << :grade
      devise_parameter_sanitizer.for(:account_update) << :area
      devise_parameter_sanitizer.for(:account_update) << :image
      devise_parameter_sanitizer.for(:account_update) << :image_cache
    end

  
end
