# frozen_string_literal: true

require 'time'
require 'messagebird/base'

module MessageBird
  class Verify < MessageBird::Base
    attr_accessor :id,
                  :href,
                  :recipient,
                  :reference,
                  :messages,
                  :status
    attr_reader   :created_datetime,
                  :valid_until_datetime

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def valid_until_datetime=(value)
      @valid_until_datetime = value_to_time(value)
    end
  end
end
