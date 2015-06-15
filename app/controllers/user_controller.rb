# encoding: utf-8
# Handles CRUD operations on Users
#
#   registration GET    /register(.:format)                     user#new
#       register POST   /register(.:format)                     user#create
#        profile GET    /profile(.:format)                      user#show
#
class UserController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]
  # Registration page
  def new

  end

  # Creates an Account
  # @param email
  # @param password
  def create
    res = current_user.create_account(params.slice(:email, :password))
    unless res.is_a? StandardError
      session[:session_token] = current_user.session_token
      redirect_to root_path
    else
      redirect_to root_path, alert: res.message
    end
  end

  # Profile page
  def show
    @profile = current_user.profile()

  end

  # Edit Profile page
  def edit
    @profile = current_user.profile()
  end

  # Update Profile
  def update
    @profile = current_user.profile()
    @profile.assign_attributes(params[:profile])
    response = current_user.update_profile(@profile)
    redirect_to home_path
  end
end
