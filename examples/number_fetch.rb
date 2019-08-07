#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

# ACCESS_KEY = 'YOUR KEY HERE'
# PHONE_NUMBER = "31612345670"

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

unless defined?(PHONE_NUMBER)
  puts 'You need to set an PHONE_NUMBER constant in this file'
end
  
begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the HLR object for the specified HLR_ID.
  number = client.number_fetch(PHONE_NUMBER)
  
  # Print the object information.
  puts "The folling number was returned as a Number object"
  puts
  puts "  number     : #{number.number}"
  puts "    country  : #{number.country}"
  puts "    region   : #{number.region}"
  puts "    locality : #{number.locality}"
  puts "    features : #{number.features}"
  puts "    tags     : #{number.tags}"
  puts "    type     : #{number.type}"
  puts "    status     : #{number.status}"
  
rescue MessageBird::ErrorException => ex
  puts
  puts 'An error occured while requesting the lookup:'
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
