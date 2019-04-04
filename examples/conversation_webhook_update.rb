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

  # Update a webhook
  webhook = client.conversation_webhook_update('00000000000000000000000000000000', :url=>'https://test.com', :events => [MessageBird::WEBHOOK_EVENT_MESSAGE_CREATED])

  # Print the object information.
  puts "The following information was returned as a Webhook object"
  puts "  id                        : #{webhook.id}"
  puts "  events                    : #{webhook.events}"
  puts "  channelId                 : #{webhook.channelId}"
  puts "  url                       : #{webhook.url}"
  puts "  status                    : #{webhook.status}"
  puts "  createdDatetime           : #{webhook.createdDatetime}"
  puts "  updatedDatetime           : #{webhook.updatedDatetime}"

rescue MessageBird::ErrorException => ex
  puts
  puts 'An error occured while creating a conversation:'
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
