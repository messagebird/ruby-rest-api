# frozen_string_literal: true

require "messagebird/base"

module MessageBird
  class ConversationChannel < MessageBird::Base
    attr_accessor :id, :name, :platformId, :status
    attr_reader :created_datetime, :updated_datetime

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def updated_datetime=(value)
      @updated_datetime = value_to_time(value)
    end
  end
end
