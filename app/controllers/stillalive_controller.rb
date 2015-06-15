# encoding: utf-8
# Namespace for StillAlive Controllers
#   stillalive GET    /stillalive(.:format)                   stillalive#index
# See {Stillalive::ContactsController}
class StillaliveController < ApplicationController
  # Redirects to {Stillalive::ContactsController#index}
  def index
    flash.keep
    redirect_to contacts_path
  end
end
