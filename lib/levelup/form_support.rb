#
# Basic support for Rails route/form helpers,
# e.g. +link_to(record)+, +form_for(record)+...
# and assignment (+assign_attributes+).
#
# Include this module in an HTTP API {Object LevelUp::Object} makes it behave
# like a classic database-backed Rails Model.
#
# @example in the Object
#   class Contact
#     include LevelUp::FormSupport
#   end
# @example then in a View
#   <%= form_for @contact do |f| %>
#     <%= f.time_select :reminder_hour %>
#   <% end %>
# @example  and in a Controller
#   @contact.assign_attributes(params[:contact])
#
module LevelUp::FormSupport

  extend ActiveSupport::Concern

  included do

    #
    # Route generation
    #

    def self.model_name
      ActiveModel::Name.new(self, nil, name.split("::").last)
    end

    # needed for choosing between `new` and `edit` routes
    # FIXME: handle new instances
    def persisted?
      true
    end

    include ActiveModel::Conversion


    #
    # Attribute assignment
    #

    include ActiveRecord::AttributeAssignment

    private

    # mass-assignment protection
    def self.attributes_protected_by_default
      ['id']
    end

    # The two following methods (stubbed here) are used for
    # multiparameter attributes assignment
    # (e.g. date/time selects params)
    def self.reflect_on_aggregation aggregation
      nil
    end

    # returns the class of the current value
    # FIXME: won't work for uninitialized fields
    def column_for_attribute name
      OpenStruct.new(klass: (send name).class)
    end
  end
end
