# frozen_string_literal: true

require 'messagebird/base'
require 'messagebird/contact_reference'

module MessageBird
  class Group < MessageBird::Base
    attr_accessor :id, :href, :name
    attr_reader :contacts, :created_datetime, :updated_datetime

    def contacts=(value)
      @contacts = MessageBird::ContactReference.new(value)
    end

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def updated_datetime=(value)
      @updated_datetime = value_to_time(value)
    end
  end
end
