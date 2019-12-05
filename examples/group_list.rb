#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

ACCESS_KEY = 'YOUR KEY HERE'

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the Group list with pagination options (skip the first 5 objects and take 10).
  limit = 10
  offset = 5
  groups = client.group_list(limit, offset)

  # Print the object information.
  puts
  puts 'The following information was returned as a Group list:'
  puts
  puts "  count           : #{groups.count}"
  puts "  limit           : #{groups.limit}"
  puts "  offset          : #{groups.offset}"
  puts "  total_count      : #{groups.total_count}"
  puts "  links           : #{groups.links}"

  unless groups.items.empty?
    group = groups[0] # Equivalent to groups.items[0]

    puts '  Group             :'
    puts "    id              : #{group.id}"
    puts "    href            : #{group.href}"
    puts "    name            : #{group.name}"
    puts "    contacts        : #{group.contacts.href}"
  end
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occurred while listing your groups:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
