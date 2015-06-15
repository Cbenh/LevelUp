# encoding: utf-8
# Handles user login/logout
#
#    login POST   /login(.:format)                        session#create
#   logout POST   /logout(.:format)                       session#destroy
#
class SessionController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]
  # @private
  def new
    return redirect_to profile_path if current_user.logged_in?
  end

  # Logs an User in
  # @param email
  # @param password
  def create
    res = current_user.login(params.slice(:email, :password).merge(application: 1))
    unless res.is_a? StandardError
      session[:session_token] = current_user.session_token
      redirect_to root_path
    else
      redirect_to root_path, alert: res.message
    end
  end

  def newpass
    res = current_user.newpass(params[:email])
    redirect_to root_path, alert: res.message
  end

  # Logs an User out
  def destroy
    current_user.logout
    reset_session
    redirect_to root_path
  end
end
