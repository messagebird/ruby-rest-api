# frozen_string_literal: true

require "messagebird/base"

module MessageBird
  class Recipient < MessageBird::Base
    attr_accessor :recipient, :status
    attr_reader :status_date_time

    def status_date_time=(value)
      @status_date_time = value_to_time(value)
    end
  end
end
