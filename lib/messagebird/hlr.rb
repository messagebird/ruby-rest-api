# frozen_string_literal: true

require "time"

require "messagebird/base"

module MessageBird
  class HLR < MessageBird::Base
    attr_accessor :id, :href, :msisdn, :network, :reference, :status, :details
    attr_reader :created_datetime, :status_datetime

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def status_datetime=(value)
      @status_datetime = value_to_time(value)
    end
  end
end
