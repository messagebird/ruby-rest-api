#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
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
  conversation = client.conversation_update('57b96dbe0fda40f0a814f5e3268c30a9', MessageBird::CONVERSATION_STATUS_ACTIVE)
  
  # Print the object information.
  puts <<EOF
The following information was returned as an updated conversation object:
  id                        : #{conversation.id}
  status                    : #{conversation.status}
  contactId                 : #{conversation.contactId}
  createdDatetime           : #{conversation.createdDatetime}
  updatedDatetime           : #{conversation.updatedDatetime}
  lastReceivedDateklme      : #{conversation.lastReceivedDatetime}
  lastUsedChannelId         : #{conversation.lastUsedChannelId}
  Messages                  :
    href                    : #{conversation.messages.href}
    totalCount              : #{conversation.messages.totalCount}
EOF

rescue MessageBird::ErrorException => ex
  puts
  puts 'An error occured while updating a conversation:'
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
