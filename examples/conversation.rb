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

  # Start a conversation
  conversation = client.conversation('conversation_id')

  # Print the object information.
  puts
  puts 'The following information was returned as a conversation object:'
  puts "  id                        : #{conversation.id}"
  puts "  status                    : #{conversation.status}"
  puts "  createdDatetime           : #{conversation.created_datetime}"
  puts "  updatedDatetime           : #{conversation.updated_datetime}"
  puts "  lastReceivedDateklme      : #{conversation.last_received_datetime}"
  puts "  lastUsedChannelId         : #{conversation.last_used_channel_id}"

  puts '  Contact                   :'
  puts "    id                      : #{conversation.contact.id}"
  puts "    href                    : #{conversation.contact.href}"
  puts "    msisdn                  : #{conversation.contact.msisdn}"
  puts "    firstName               : #{conversation.contact.first_name}"
  puts "    lastName                : #{conversation.contact.last_name}"
  puts "    custom1                 : #{conversation.contact.custom_details.custom1}"
  puts "    custom2                 : #{conversation.contact.custom_details.custom2}"
  puts "    custom3                 : #{conversation.contact.custom_details.custom3}"
  puts "    custom4                 : #{conversation.contact.custom_details.custom4}"
  puts "    createdDatetime         : #{conversation.contact.created_datetime}"
  puts "    updatedDatetime         : #{conversation.contact.updated_datetime}"

  puts '  Channels                  :'
  conversation.channels.each do |channel|
    puts "    id                      : #{channel.id}"
    puts "    name                    : #{channel.name}"
    puts "    platformId              : #{channel.platform_id}"
    puts "    createdDatetime         : #{channel.created_datetime}"
    puts "    updatedDatetime         : #{channel.updated_datetime}"
    puts
  end

  puts '  Messages                  :'
  puts "    href                    : #{conversation.messages.href}"
  puts "    total_count              : #{conversation.messages.total_count}"
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while creating a conversation:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
