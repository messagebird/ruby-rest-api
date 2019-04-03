require 'messagebird/base'
require 'messagebird/contact'
require 'messagebird/conversation_channel'

module MessageBird 
  class Conversation < MessageBird::Base
    attr_accessor :id, :contact, :channels, :status, :messages,
                  :createdDatetime, :updatedDatetime, :lastReceivedDatetime, :lastUsedChannelId

    def contact=(value)
      @contact = Contact.new(value)
    end

    def channels=(json)
      @channels = json.map { |c| MessageBird::ConversationChannel.new(c) }
    end

    def messages=(value)
      @messages = MessageBird::MessageReference.new(value) 
    end
   
    def createdDatetime=(value)
      @createdDatetime = value_to_time(value)
    end

    def updatedDatetime=(value)
      @updatedDatetime = value_to_time(value)
    end

    def lastReceivedDatetime=(value)
      @lastReceivedDatetime = value_to_time(value)
    end
  end 
end 
