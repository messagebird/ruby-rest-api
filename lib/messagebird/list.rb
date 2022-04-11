# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class List < MessageBird::Base
    attr_accessor :offset, :limit, :count, :total_count, :links
    attr_reader :items

    # type will be used to create objects for the items, e.g.
    # List.new(Contact, {}).
    def initialize(type, json)
      @type = type

      super(json)
    end

    def items=(value)
      @items = value.map { |i| @type.new i }
    end

    def [](index)
      @items[index]
    end
  end
end
