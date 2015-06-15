# encoding: utf-8
# Base Class for all Controllers
# encoding: utf-8
#
# Ensures
# - protection against CSRF
# - user is logged-in
# - user owns the application
#
# Provides some helper methods
class ApplicationController < ActionController::Base
  protect_from_forgery


  # @!group helpers

  helper_method :current_user

  protected

  # @return [LevelUp::Client] the current user
  def current_user
    @current_user ||= LevelUp::Client.new(session[:session_token])
  end


  # @!group before_filter

  before_filter :require_login, :require_app

  private

  # Redirects back if the current user is not logged-in
  def require_login
    unless current_user.logged_in?
      redirect_to (request.referer || root_path),
        alert: "Vous devez vous connecter pour effectuer cette action"
    end
  end

  # Redirects back if the current user has not downloaded the app associated
  # with the Controller
  #
  # The app is deduced from the Controller's name
  def require_app
    name = self.class.name
            .gsub(/Controller$/, '').split('::').first
            .downcase.to_sym

    app_id, app_name = {
      dareforget: [1, "DareForget"],
      dontpanic:  [2, "DontPanic" ],
      stillalive: [3, "StillAlive"],
      foodchain:  [4, "FoodChain" ],
    }[name]

    return if app_id.nil?

    unless current_user.downloaded? app_id
      redirect_to (request.referer || root_path),
        alert: "Vous devez télécharger #{app_name} pour effectuer cette action"
    end
  end
end
