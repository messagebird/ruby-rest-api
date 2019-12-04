# frozen_string_literal: true

require "time"

require "messagebird/base"

module MessageBird
  class Verify < MessageBird::Base
    attr_accessor :id, :recipient, :reference, :status, :href
    attr_reader :created_datetime, :valid_until_date_time

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def valid_until_date_time=(value)
      @valid_until_date_time = value_to_time(value)
    end
  end
end
