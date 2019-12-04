# frozen_string_literal: true

require "messagebird/base"
require "messagebird/custom_details"
require "messagebird/group_reference"
require "messagebird/message_reference"

module MessageBird
  class Contact < MessageBird::Base
    attr_accessor :id, :href, :msisdn, :firstName, :lastName
    attr_reader :custom_details, :groups, :messages, :created_datetime, :updated_date_time

    def custom_details=(value)
      @custom_details = MessageBird::CustomDetails.new(value)
    end

    def groups=(value)
      @groups = MessageBird::GroupReference.new(value)
    end

    def messages=(value)
      @messages = MessageBird::MessageReference.new(value)
    end

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def updated_date_time=(value)
      @updated_date_time = value_to_time(value)
    end
  end
end
