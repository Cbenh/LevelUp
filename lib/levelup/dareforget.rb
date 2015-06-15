require "levelup/object"

module LevelUp
  #
  # Implements the methods of the DareForget API
  #
  module DareForget
    include LevelUp::Object

    #
    # Returns the Items followed by the User
    #
    # @return [Array] an Array of {Item}s
    def followed_items
      get("dareforget/getFollowedItems", Item,
        :session_token
      )
    end

    #
    # Returns the Items available for the User
    #
    # @return [Array] an Array of {Item}s
    def available_items
      get("dareforget/getAvailableItems", Item,
        :session_token
      )
    end

    #
    # Returns the details of a followed Object from its ID
    # @param  id [Fixnum]
    #
    # @return [Item]
    def item_infos(id)
      get("dareforget/getItemInfo", Item,
        :session_token,
        itemId: id
      )
    end

    #
    # Returns the details of a not-followed Object from its ID
    # @param  id [Fixnum]
    #
    # @return [Item]
    def find_item(id)
      available_items.find{|i| i.id == id.to_i }
    end

    #
    # Returns the estimated date of stockout for an Object from its ID
    # @param  id [Fixnum]
    #
    # @return [DateTime]
    def stockout_estimation(id)
      get("dareforget/stockoutEstimation", EstimatedDate,
        :session_token,
        itemId: id
      )
    end

    #
    # Follows an Item
    # @param  item [Item]
    #   the Item's +nb_user+, +remind_at+, +reminder_interval+ and +stock+ must
    #   be set
    #
    # @return [DateTime] an estimated date of stockout
    def follow_item(item)
      get("dareforget/followItem", EstimatedDate,
        :session_token,
        itemId: item.id,
        currentStock: item.stock,
        nbUsers: item.nb_users,
        reminderInterval: item.reminder_interval,
        reminderHour: [:hour, :min].map { |m| item.remind_at.send(m)
                                                .to_s.rjust(2, "0") }.join
      )
    end

    #
    # Unfollows an Item given its ID
    # @param  id [Fixnum]
    #
    # @return [Boolean] true if the Item has been unfollowed
    def unfollow_item(id)
      get("dareforget/unfollowItem", Boolean,
        :session_token,
        itemId: id
      )
    end

    #
    # Update an Item followed by the user
    # @param  item [Item] the updated Item
    #
    # @return [DateTime] an estimated date of stockout
    def update_item(item)
      get("dareforget/updateItem", EstimatedDate,
        :session_token,
        itemId: item.id,
        currentStock: item.stock,
        nbUsers: item.nb_users,
        reminderInterval: item.reminder_interval,
        reminderHour: [:hour, :min].map { |m| item.remind_at.send(m)
                                                .to_s.rjust(2, "0") }.join,
        standby: item.standby
      )
    end
  end
end
