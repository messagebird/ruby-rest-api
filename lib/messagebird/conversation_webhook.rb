# frozen_string_literal: true

require "messagebird/base"

module MessageBird
  class ConversationWebhook < MessageBird::Base
    attr_accessor :id, :events, :channel_id, :url, :status, :created_datetime, :updated_datetime
  end
end
