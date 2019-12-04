# frozen_string_literal: true

require "messagebird/base"

module MessageBird
  class ConversationMessage < MessageBird::Base
    attr_accessor :id, :conversationId, :channel_id, :direction, :status,
                  :type, :content, :created_datetime, :updated_datetime, :fallback
  end
end
