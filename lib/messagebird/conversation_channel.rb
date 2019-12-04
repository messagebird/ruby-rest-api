# frozen_string_literal: true

require "messagebird/base"

module MessageBird
  class ConversationChannel < MessageBird::Base
    attr_accessor :id, :name, :platformId, :status
    attr_reader :created_datetime, :updated_date_time

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def updated_date_time=(value)
      @updated_date_time = value_to_time(value)
    end
  end
end
