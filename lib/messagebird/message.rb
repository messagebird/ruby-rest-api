# frozen_string_literal: true

require "messagebird/base"
require "messagebird/recipient"

module MessageBird
  class Message < MessageBird::Base
    attr_accessor :id, :href, :direction, :type, :originator, :body, :reference,
                  :validity, :gateway, :typeDetails, :datacoding, :mclass
    attr_reader :scheduled_date_time, :created_datetime, :recipients

    def scheduled_date_time=(value)
      @scheduled_date_time = value_to_time(value)
    end

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def recipients=(json)
      json["items"] = json["items"].map { |r| Recipient.new(r) }
      @recipients = json
    end
  end
end
