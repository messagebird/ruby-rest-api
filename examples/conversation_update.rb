#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

# ACCESS_KEY = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Update a conversation
  conversation = client.conversation_update('57b96dbe0fda40f0a814f5e3268c30a9', MessageBird::Conversation::CONVERSATION_STATUS_ACTIVE)

  # Print the object information.
  puts <<~INFO
    The following information was returned as an updated conversation object:
      id                        : #{conversation.id}
      status                    : #{conversation.status}
      contact_id                : #{conversation.contact_id}
      created_datetime          : #{conversation.created_datetime}
      updated_datetime          : #{conversation.updated_datetime}
      lastReceivedDateklme      : #{conversation.lastReceivedDatetime}
      last_used_channel_id         : #{conversation.last_used_channel_id}
      Messages                  :
        href                    : #{conversation.messages.href}
        total_count             : #{conversation.messages.total_count}
  INFO
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while updating a conversation:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
