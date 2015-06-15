require "levelup/object"

module LevelUp
  #
  # Implements the methods of the StillAlive API
  #
  module StillAlive
    include LevelUp::Object
    #
    # Returns the Contacts followed by the User
    #
    # @return [Array] an Array of {Contact}s
    def followed_contacts
      get("stillalive/getFollowedContacts", Contact,
        :session_token
      )
    end

    #
    # Returns a Contact followed by the User given its id
    #
    # @return [Contact]
    def find_contact(id)
      followed_contacts.find {|c| c.id == id.to_i }
    end

    #
    # Unfollows a contact given its ID
    # @param  id [Fixnum]
    #
    # @return [Boolean] true if the Contact has been unfollowed
    def unfollow_contact(id)
      get("stillalive/unfollowContact", Boolean,
        :session_token,
        contactId: id
      )
    end

    #
    # Update an Contact followed by the user
    # @param  contact [Contact] the updated Contact
    #
    # @return "" or 0
    def update_contact(contact)
      get("stillalive/updateContact", Boolean,
        :session_token,
        contactId: contact.id,
        name: contact.name,
        trackCalls: contact.track_calls,
        trackSms: contact.track_sms,
        trackEmails: contact.track_emails,
        lastInteraction: contact.last_interaction,
        reminderHour: [:hour, :min].map { |m| contact.reminder_hour.send(m).to_s.rjust(2, "0") }.join,
        daysInterval: contact.days_interval,
        standby: contact.standby
      )
    end

    def reset_contact(id)
      get("stillalive/resetContact", Boolean,
        :session_token,
        contactId: id
        )
    end
  end
end
