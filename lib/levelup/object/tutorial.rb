module LevelUp::Object
  #
  # A DontPanic Tutorial
  #
  # @attr id [Fixnum]
  # @attr title [String]
  # @attr image [String]
  # @attr description [String]
  # @attr step_count [String]
  # @attr score [Fixnum]
  # @attr downloads [Fixnum]
  # @attr category_id [Fixnum]
  # @attr published_at [Date]
  # @attr steps [Array] the Tutorial's {Step Steps}
  class Tutorial
    attr_accessor :id,
                  :title,
                  :image,
                  :description,
                  :step_count,
                  :score,
                  :downloads,
                  :category_id,
                  :published_at,
                  :steps

    #
    # Builds an Array of Tutorials from a JSON response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of Tutorials
    def self.build response
      if response.has_key? "Headers"
        response["Headers"] ? response["Headers"].map {|i| new i } : []
      elsif response["Tuto"]
        tutorial = new response["Tuto"]["Header"]
        tutorial.build_steps response["Tuto"]["Steps"], tutorial.step_count
        tutorial
      end
    end

    #
    # Creates an Item from a JSON API response
    # @param  attributes [Hash] JSON response
    def initialize attributes
      @id                = attributes["TutoId"]
      @title             = attributes["Title"]
      @image             = attributes["ImgUrl"]
      @description       = attributes["Description"]
      @step_count        = attributes["NbTotalSteps"]
      @score             = attributes["Grade"]
      @downloads         = attributes["DownloadCount"]
      @category_id       = attributes["Category"]
      @published_at      = Date.parse(attributes["Publication"])
    end

    # @private
    def build_steps json_steps, step_count
      @steps = json_steps.map{ |s| Step.new s, step_count }
    end

    # @param page [Fixnum]
    # @return [Step] a {Step} given its page
    def step page
      steps[page - 1]
    end

    # A Step of a DontPanic {Tutorial Tutorial}
    # @attr page [Fixnum]
    # @attr title [String]
    # @attr image [String]
    # @attr content [String]
    class Step
      attr_accessor :page,
                    :title,
                    :image,
                    :content

      # @private
      def initialize attributes, page_count
        @id                = attributes["TutoId"]
        @page              = attributes["PageNumber"]
        @title             = attributes["Title"]
        @image             = attributes["ImgUrl"]
        @content           = attributes["Content"]
        @page_count = page_count
      end

      # @return [Fixnum] the page number of the previous page
      def prev
        page > 1 ? page - 1 : nil
      end

      # @return [Fixnum] the page number of the next page
      def next
        page < @page_count ? page + 1 : nil
      end
    end
  end
end
