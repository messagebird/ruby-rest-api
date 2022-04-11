#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib/")
require 'messagebird'

# ACCESS_KEY = 'YOUR KEY HERE'
# GROUP_NAME = 'YOUR GROUP NAME HERE'

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

unless defined?(GROUP_NAME)
  puts 'You need to set an GROUP_NAME constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Create a new Group object.
  group = client.group_create(GROUP_NAME)

  # Print the object information.
  puts
  puts '  Group             :'
  puts "    id              : #{group.id}"
  puts "    href            : #{group.href}"
  puts "    name            : #{group.name}"
  puts "    contacts        : #{group.contacts.href}"
  puts
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occurred while creating a group:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
