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

  # Fetch the messages list
  offset = 0
  limit = 10
  list = client.conversation_messages_list("00000000000000000000000000000000", limit, offset)

  # Print the object information.
  #
  puts "The following information was returned as a messages list:"
  puts
  puts "  count           : #{list.count}"
  puts "  limit           : #{list.limit}"
  puts "  offset          : #{list.offset}"
  puts "  totalCount      : #{list.totalCount}"
  puts "  links           : #{list.links}"
  puts

  list.items.each do |msg|
    puts "Message:"
    puts "  id                        : #{msg.id}"
    puts "  conversationId            : #{msg.conversationId}"
    puts "  channelId                 : #{msg.channelId}"
    puts "  direction                 : #{msg.direction}"
    puts "  type                      : #{msg.type}"
    puts "  status                    : #{msg.status}"
    puts "  content                   : #{msg.content}"
    puts "  createdDatetime           : #{msg.createdDatetime}"
    puts "  updatedDatetime           : #{msg.updatedDatetime}"
    puts
  end

rescue MessageBird::ErrorException => ex
  puts
  puts "An error occured while creating a conversation:"
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
