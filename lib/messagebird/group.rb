# frozen_string_literal: true

require "messagebird/base"
require "messagebird/contact_reference"

module MessageBird
  class Group < MessageBird::Base
    attr_accessor :id, :href, :name
    attr_reader :contacts, :created_datetime, :updated_date_time

    def contacts=(value)
      @contacts = MessageBird::ContactReference.new(value)
    end

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def updated_date_time=(value)
      @updated_date_time = value_to_time(value)
    end
  end
end
