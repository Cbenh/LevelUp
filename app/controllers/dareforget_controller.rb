# encoding: utf-8
# Namespace for DareForget Controllers
#   dareforget GET    /dareforget(.:format)                   dareforget#index
# See {Dareforget::ItemsController}
class DareforgetController < ApplicationController
  # Redirects to {Dareforget::ItemsController#index}
  def index
    flash.keep
    redirect_to items_path
  end
end
