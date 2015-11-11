module XCRes
  class Section

    # @return [String]
    #         the name / key of the section
    attr_reader :name

    # @return [Hash{String => String|Hash}]
    #         the items of the section
    attr_reader :items

    # @return [Hash]
    #         options of the section for serialization
    attr_accessor :options

    # Initialize a new section
    #
    # @param  [String] name
    #         see #name
    #
    # @param  [Hash] items
    #         see #items
    #
    # @param  [Hash] options
    #         see #options
    #
    #
    def initialize(name, items, options={})
      @name  = name
      @items = items
      @options = options
    end

    # Compare two sections
    #
    # @param  [Section] other
    #         another section to compare to this one
    #
    # @return [Bool]
    #         whether contents are equal
    #
    def ==(other)
      self.name == other.name \
        && self.items == other.items \
        && self.options == other.options
    end

    alias eql? ==

  end
end
