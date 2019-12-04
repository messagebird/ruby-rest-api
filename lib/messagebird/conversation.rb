# frozen_string_literal: true

require "messagebird/base"
require "messagebird/contact"
require "messagebird/conversation_channel"

module MessageBird
  class Conversation < MessageBird::Base
    attr_accessor :id, :status, :lastUsedChannelId, :contactId
    attr_reader :contact, :channels, :messages, :created_datetime,
                :updated_datetime, :last_received_datetime

    CONVERSATION_STATUS_ACTIVE = "active"
    CONVERSATION_STATUS_ARCHIVED = "archived"
    WEBHOOK_EVENT_CONVERSATION_CREATED = "conversation.created"
    WEBHOOK_EVENT_CONVERSATION_UPDATED = "conversation.updated"
    WEBHOOK_EVENT_MESSAGE_CREATED = "message.created"
    WEBHOOK_EVENT_MESSAGE_UPDATED = "message.updated"

    def contact=(value)
      @contact = Contact.new(value)
    end

    def channels=(json)
      @channels = json.map { |c| MessageBird::ConversationChannel.new(c) }
    end

    def messages=(value)
      @messages = MessageBird::MessageReference.new(value)
    end

    def created_datetime=(value)
      @created_datetime = value_to_time(value)
    end

    def updated_datetime=(value)
      @updated_datetime = value_to_time(value)
    end

    def last_received_datetime=(value)
      @last_received_datetime = value_to_time(value)
    end
  end
end
