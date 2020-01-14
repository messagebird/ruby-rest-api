#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

ACCESS_KEY = ''
VERIFY_ID  = ''
TOKEN      = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

unless defined?(VERIFY_ID)
  puts 'You need to set an VERIFY_ID constant in this file'
  exit 1
end

unless defined?(TOKEN)
  puts 'You need to set an TOKEN constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Verify an OTP message with a token
  otp = client.verify_token(VERIFY_ID, TOKEN)

  # Print the object information.
  puts
  puts 'The following information was returned as an OTP object:'
  puts
  puts "  id                  : #{otp.id}"
  puts "  recipient           : #{otp.recipient}"
  puts "  reference           : #{otp.reference}"
  puts "  status              : #{otp.status}"
  puts "  href                : #{otp.href}"
  puts "  createdDatetime     : #{otp.created_datetime}"
  puts "  validUntilDatetime  : #{otp.valid_until_date_time}"
  puts
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while requesting an OTP object:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
