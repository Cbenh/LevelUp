# encoding: utf-8
#
# Implements DareForget operations on {LevelUp::Object::Item Items}
#
#    available_items GET    /dareforget/items/available(.:format)   dareforget/items#available
#           new_item GET    /dareforget/items/new/:id(.:format)     dareforget/items#new
#              items GET    /dareforget/items(.:format)             dareforget/items#index
#                    POST   /dareforget/items(.:format)             dareforget/items#create
#          edit_item GET    /dareforget/items/:id/edit(.:format)    dareforget/items#edit
#               item GET    /dareforget/items/:id(.:format)         dareforget/items#show
#                    PUT    /dareforget/items/:id(.:format)         dareforget/items#update
#                    DELETE /dareforget/items/:id(.:format)         dareforget/items#destroy
#
class Dareforget::ItemsController < ApplicationController
  # Page de Selection
  def available
    @items = current_user.available_items
  end

  # Page de Monitoring
  def index
    @items = current_user.followed_items
    @sorts = [
      ["Date d'ajout", "added_date"],
      ["Alphabet", "name"],
      ["Date de rupture", "stockout_at"]
          ]
    case params[:sort]
    when "added_date"
      @items = @items.sort_by(&:added_date).reverse
    when "name"
      @items = @items.sort_by(&:name)
    when "stockout_at"
      @items = @items.sort_by(&:stockout_at)
    end
    if @items.is_a? StandardError
      return redirect_to (request.referer || root_path), alert: @items.message
    end
    if @items.empty?
      redirect_to available_items_path, notice: "Vous ne suivez aucun item pour le moment"
    end
  end

  # ~Pop-up de sélection
  # @param id
  def new
    @item = current_user.find_item(params[:id])
  end

  # Creates an Item ownership
  # @param id Item id
  # @param item [Hash] Item attributes
  def create
    item = current_user.find_item(params[:id])
    item.assign_attributes(params[:item])
    response = current_user.follow_item(item)
    unless response.is_a? StandardError
      redirect_to items_path, notice: "Item suivi"
    else
      redirect_to new_item_path(item.id), alert: response.message
    end
  end

  # ~Pop-up de monitoring
  # @param id
  def edit
    @item = current_user.item_infos(params[:id])
  end

  # Redirects to {#edit}
  # @param id
  def show
    flash.keep
    redirect_to edit_item_path params[:id]
  end

  # Updates an Item ownership
  # @param id Item id
  # @param item [Hash] Item attributes
  def update
    item = current_user.item_infos(params[:id])
    item.assign_attributes(params[:item])
    response = current_user.update_item(item)
    unless response.is_a? StandardError
      redirect_to items_path, notice: "Item mis a jour"
    else
      redirect_to edit_item_path(item), alert: response.message
    end
  end

  # Deletes an Item ownership
  # @param id
  def destroy
    response = current_user.unfollow_item(params[:id])
    redirect_to items_path
  end
end
