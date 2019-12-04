#!/usr/bin/env ruby
# frozen_string_literal: true

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib/")
require "messagebird"

# ACCESS_KEY = ''

unless defined?(ACCESS_KEY)
  puts "You need to set an ACCESS_KEY constant in this file"
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Reply to a conversation
  msg = client.conversation_reply("00000000000000000000000000000000", type: "text", content: { text: "Hi there" })

  # Print the object information.
  puts <<EOF
The following information was returned as a Message object:
    id                        : #{msg.id}
    conversationId            : #{msg.conversationId}
    channelId                 : #{msg.channelId}
    direction                 : #{msg.direction}
    type                      : #{msg.type}
    status                    : #{msg.status}
    content                   : #{msg.content}
    createdDatetime           : #{msg.createdDatetime}
    updatedDatetime           : #{msg.updatedDatetime}
EOF

rescue MessageBird::ErrorException => ex
  puts
  puts "An error occured while updating a conversation:"
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
