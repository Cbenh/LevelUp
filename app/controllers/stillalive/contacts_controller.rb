# encoding: utf-8
# Implement StillAlive operations on {LevelUp::Object::Contact Contact}s
#
#       contacts GET    /stillalive/contacts(.:format)          stillalive/contacts#index
#                POST   /stillalive/contacts(.:format)          stillalive/contacts#create
#   edit_contact GET    /stillalive/contacts/:id/edit(.:format) stillalive/contacts#edit
#        contact GET    /stillalive/contacts/:id(.:format)      stillalive/contacts#show
#                PUT    /stillalive/contacts/:id(.:format)      stillalive/contacts#update
#                DELETE /stillalive/contacts/:id(.:format)      stillalive/contacts#destroy
class Stillalive::ContactsController < ApplicationController
  # Page de monitoring
  # @param sort (name|last_interaction|next_interaction)
  def index
    @contacts = current_user.followed_contacts
    case params[:sort].try(:to_sym)
    when :name
      @contacts = @contacts.sort_by(&:name)
    when :last_interaction
      @contacts = @contacts.sort_by(&:last_interaction)
    when :next_interaction
      @contacts = @contacts.sort_by(&:next_interaction)
    end
  end

  # Redirect to {#edit}
  # @param id
  def show
    flash.keep
    redirect_to edit_contact_path params[:id]
  end

  # Update a Contact
  # @param contact [Hash]
  def update
    @contact = current_user.find_contact(params[:id])
    @contact.assign_attributes(params[:contact])
    response = current_user.update_contact(@contact)
    unless response.is_a? StandardError
      redirect_to contacts_path, notice: "Changements enregistrés !"
    else
      redirect_to edit_contact_path(@contact), alert: response.message
    end
  end

  # Display the edition form for a Contact (~Pop-up de monitoring)
  # @param id
  def edit
    @contact = current_user.find_contact(params[:id])
  end


 # Reset the time counter
  # @param id
  def reset
    response = current_user.reset_contact(params[:id])
    unless response.is_a? StandardError
      redirect_to stillalive_path, notice: "Compteur remis à 0", :class => "alert-stillalive"
    else
      redirect_to stillalive_path, alert: response.message
    end
  end

  # Destroy a Contact
  # @param id
  def destroy
    response = current_user.unfollow_contact(params[:id])
    unless response.is_a? StandardError
      redirect_to stillalive_path, notice: "Contact supprimé"
    else
      redirect_to stillalive_path, alert: response.message
    end
  end
end
