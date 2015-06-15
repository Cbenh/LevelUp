require "levelup/object"

module LevelUp
  #
  # Implements the methods of the core API
  #
  module Core
    include LevelUp::Object
    #
    # Connects an User and stores its session token
    # @param  params [Hash] must contain an +:email+ and a +:password+
    #
    # @return [SessionToken]
    def login params={}
      response = get("core/login", SessionToken,
        :magic,
        :source,
        params
      )
      @session_token = response
    end

    #
    # Creates an account with the parameters, connects the User and stores its session token
    # @param  params [Hash] must contain an +:email+ and a +:password+
    #
    # @return [SessionToken]
    def create_account params={}
      response = get("core/createAccount", SessionToken,
        :magic,
        :source,
        params,
        application: 1
      )
      @session_token = response
    end

    # @return [Fixnum] the API version of the core
    def api_version
      response = get("core/currentApiVersion", Version)
    end

    #
    # Disconnectsthe User and removes its session token
    #
    # @return [Boolean]
    def logout
      response = get("core/logout", Boolean, :session_token)
      @session_token = nil
      response
    end

    #
    # Checks if the client has downloaded an app
    # @param  app_id [Fixnum] the id of the application to check
    #
    # @return [Boolean]
    def downloaded? app_id
      get("core/hasUserDownloadedApp", Boolean,
        :session_token,
        appId: app_id
      )
    end

    #
    # Gets the client profile
    #
    # @return [Hash]
    def profile
      get("core/getUserProfile", Profile, :session_token)
    end

    def update_profile(profile)
      get("core/updateUserProfile", Boolean,
      :session_token,
      email: profile.email,
      newPassword: profile.new_password,
      pseudo: profile.pseudo,
      gender: profile.gender,
      birthDate: profile.birth_date,
      avatar: profile.avatar
      )
    end

    def new_password(email)
      get("core/sendNewPassword", Boolean,
      email: email
      )
    end

    #
    # Checks if the User is logged in
    #
    # @return [Boolean]
    def logged_in?
      @session_token != nil
    end
  end
end
