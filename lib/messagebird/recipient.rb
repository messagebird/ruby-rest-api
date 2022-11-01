# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class Recipient < MessageBird::Base
    attr_accessor :recipient, :status
    attr_reader :status_datetime

    def status_datetime=(value)
      @status_datetime = value_to_time(value)
    end
  end
end
