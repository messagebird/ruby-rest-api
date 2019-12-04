#!/usr/bin/env ruby
# frozen_string_literal: true

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib/")
require "messagebird"

# ACCESS_KEY = ''
# HLR_ID = ''

unless defined?(ACCESS_KEY)
  puts "You need to set an ACCESS_KEY constant in this file"
  exit 1
end

unless defined?(HLR_ID)
  puts "You need to set an HLR_ID constant in this file"
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the HLR object for the specified HLR_ID.
  hlr = client.hlr(HLR_ID)

  # Print the object information.
  puts
  puts "The following information was returned as an HLR object:"
  puts
  puts "  id              : #{hlr.id}"
  puts "  href            : #{hlr.href}"
  puts "  msisdn          : #{hlr.msisdn}"
  puts "  reference       : #{hlr.reference}"
  puts "  status          : #{hlr.status}"
  puts "  created_datetime : #{hlr.created_datetime}"
  puts "  statusDatetime  : #{hlr.statusDatetime}"
  puts

rescue MessageBird::ErrorException => e
  puts
  puts "An error occured while requesting an HLR object:"
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
