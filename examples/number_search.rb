#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

# ACCESS_KEY = 'YOUR KEY HERE'

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the HLR object for the specified HLR_ID.
  numbers = client.number_search('NL', limit: 5)

  # Print the object information.
  puts 'The folling numbers was returned as a list of Number objects'
  puts
  numbers.items.each do |number|
    puts "  number     : #{number.number}"
    puts "    country  : #{number.country}"
    puts "    region   : #{number.region}"
    puts "    locality : #{number.locality}"
    puts "    features : #{number.features}"
    puts "    type     : #{number.type}"
  end
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while requesting the lookup:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
