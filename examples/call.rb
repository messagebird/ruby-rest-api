#!/usr/bin/env ruby

# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib/")
require 'messagebird'

ACCESS_KEY = 'YOUR ACCESS KEY HERE'

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Start a conversation
  calls = client.call_list(10, 0)

  calls.items.each do |call|
    puts "Call ID: #{call.id}"
  end
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while listing the calls:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
