#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib/")
require 'messagebird'

# ACCESS_KEY = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  messages = client.message_list(status: 'scheduled')

  # Print the object information.
  puts
  puts 'The following information was returned as a Message list:'
  puts
  puts "  count           : #{messages.count}"
  puts "  limit           : #{messages.limit}"
  puts "  offset          : #{messages.offset}"
  puts "  totalCount      : #{messages.total_count}"
  puts "  links           : #{messages.links}"
  unless messages.items.empty?
    msg = messages[0] # Equivalent to messages.items[0]
    # Print the object information.
    puts
    puts 'The following information was returned as a Message object:'
    puts
    puts "  id                  : #{msg.id}"
    puts "  href                : #{msg.href}"
    puts "  direction           : #{msg.direction}"
    puts "  type                : #{msg.type}"
    puts "  originator          : #{msg.originator}"
    puts "  body                : #{msg.body}"
    puts "  reference           : #{msg.reference}"
    puts "  validity            : #{msg.validity}"
    puts "  gateway             : #{msg.gateway}"
    puts "  typeDetails         : #{msg.typeDetails}"
    puts "  datacoding          : #{msg.datacoding}"
    puts "  mclass              : #{msg.mclass}"
    puts "  scheduledDateTime   : #{msg.scheduled_date_time}"
    puts "  createdDatetime     : #{msg.created_datetime}"
    puts "  recipients          : #{msg.recipients}"
    puts
  end
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occurred while listing your messages:'
  puts
  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
