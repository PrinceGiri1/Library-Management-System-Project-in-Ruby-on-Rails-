class ApplicationController < ActionController::Base
  # Makes sure that no page is accessible by unauthenticated user;
  # Refer: https://stackoverflow.com/a/43434226/6543250
  #
  before_action :authenticate_user!, unless: :devise_controller?
  include Pundit
  protect_from_forgery

  # def current_user
  #   return unless session[:user_id]
  #   @current_user ||= User.find(session[:user_id])
  # end
  protected
  def redirect_to_default
    redirect_to root_url
  end
end
