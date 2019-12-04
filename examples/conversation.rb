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

  # Start a conversation
  conversation = client.conversation("conversationId")

  # Print the object information.
  puts
  puts "The following information was returned as a conversation object:"
  puts "  id                        : #{conversation.id}"
  puts "  status                    : #{conversation.status}"
  puts "  createdDatetime           : #{conversation.createdDatetime}"
  puts "  updatedDatetime           : #{conversation.updatedDatetime}"
  puts "  lastReceivedDateklme      : #{conversation.lastReceivedDatetime}"
  puts "  lastUsedChannelId         : #{conversation.lastUsedChannelId}"

  puts "  Contact                   :"
  puts "    id                      : #{conversation.contact.id}"
  puts "    href                    : #{conversation.contact.href}"
  puts "    msisdn                  : #{conversation.contact.msisdn}"
  puts "    firstName               : #{conversation.contact.firstName}"
  puts "    lastName                : #{conversation.contact.lastName}"
  puts "    custom1                 : #{conversation.contact.customDetails.custom1}"
  puts "    custom2                 : #{conversation.contact.customDetails.custom2}"
  puts "    custom3                 : #{conversation.contact.customDetails.custom3}"
  puts "    custom4                 : #{conversation.contact.customDetails.custom4}"
  puts "    createdDatetime         : #{conversation.contact.createdDatetime}"
  puts "    updatedDatetime         : #{conversation.contact.updatedDatetime}"

  puts "  Channels                  :"
  conversation.channels.each do |channel|
    puts "    id                      : #{channel.id}"
    puts "    name                    : #{channel.name}"
    puts "    platformId              : #{channel.platformId}"
    puts "    createdDatetime         : #{channel.createdDatetime}"
    puts "    updatedDatetime         : #{channel.updatedDatetime}"
    puts
  end

  puts "  Messages                  :"
  puts "    href                    : #{conversation.messages.href}"
  puts "    totalCount              : #{conversation.messages.totalCount}"

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
