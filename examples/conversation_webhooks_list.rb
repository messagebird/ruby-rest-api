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

  # Fetch the Webhooks list
  offset = 0
  limit = 10
  webhooks = client.conversation_webhooks_list(limit, offset)

  # Print the object information.
  puts 'The following information was returned as a Webhooks list:'
  puts
  puts "  count           : #{webhooks.count}"
  puts "  limit           : #{webhooks.limit}"
  puts "  offset          : #{webhooks.offset}"
  puts "  totalCount      : #{webhooks.total_count}"
  puts
  webhooks.items.each do |webhook|
    puts 'Webhook:'
    puts "  id                        : #{webhook.id}"
    puts "  events                    : #{webhook.events}"
    puts "  channelId                 : #{webhook.channel_id}"
    puts "  url                       : #{webhook.url}"
    puts "  status                    : #{webhook.status}"
    puts "  createdDatetime           : #{webhook.created_datetime}"
    puts "  updatedDatetime           : #{webhook.updated_datetime}"
  end
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
