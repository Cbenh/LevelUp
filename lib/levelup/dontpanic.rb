require "levelup/object"

module LevelUp
  #
  # Implement DontPanic actions on {Tutorial Tutorial}s and {Category Categories}
  #
  module DontPanic
    include LevelUp::Object
    # @return [Array] the User's {Tutorial Tutorials}
    def tutorials
      get("dontpanic/getUserTutorialHeaders", Tutorial,
        :session_token
      )
    end

    # @param [Fixnum] id
    #
    # @return [Tutorial] a tutorial
    def tutorial id
      get("dontpanic/getTuto", Tutorial,
        :session_token,
        tutoId: id
      )
    end

    # @param [Fixnum] max
    #
    # @return [Array] the newest {Tutorial Tutorials}
    def newest_tutorials max=5
      get("dontpanic/getNewestTutoHeaders", Tutorial,
        maxResults: max
      )
    end

    # @param [String] query
    # @param [Fixnum] max
    #
    # @return [Array] the {Tutorial Tutorials} correspondig to a +query+
    def search_tutorials query, max=5
      get("dontpanic/searchTutoHeader", Tutorial,
        :session_token,
        search: query,
        maxResults: max
      )
    end

    # @return [Array] the list of {Category Categories}
    def dontpanic_categories
      get("dontpanic/getCategories", Category,
        :session_token
      )
    end

    # @param id [Fixnum] the id of the {Category Category}
    # @option options [Fixnum] sort (1)
    # @option options [Fixnum] max (5)
    #
    # @return [Array] the {Tutorial Tutorials} of a Category
    def dontpanic_category_tutorials id, options={}
      options.reverse_merge!(sort: 1, max: 5)
      get("dontpanic/getTutoHeadersInCategory", Tutorial,
        :session_token,
        categoryId: id,
        sort: options[:sort],
        max: options[:max]
      )
    end

    # Download a {Tutorial Tutorial}
    # @param [Fixnum] id
    #
    # @return [Boolean]
    def download_tutorial id
      get("dontpanic/registerTutoForDownload", Boolean,
        :session_token,
        tutorialId: id
      )
    end

    # Delete a {Tutorial Tutorial}
    # @param [Fixnum] id
    #
    # @return [Boolean]
    def delete_tutorial id
      get("dontpanic/removeTutoFromUserList", Boolean,
        :session_token,
        tutorialId: id
      )
    end

    def update_grade id, score
      get("dontpanic/gradeTutorial", Boolean,
        :session_token,
        tutorialId: id,
        grade: score 
        )
    end

    # Test if the User owns a {Tutorial Tutorial}
    #
    # @return [Bool]
    def has_tutorial? id
      tutorials.find{|t| t.id == id.to_i } != nil
    end
  end
end
