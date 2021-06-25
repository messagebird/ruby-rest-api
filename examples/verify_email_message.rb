#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

# ACCESS_KEY = ''
# MESSAGE_ID = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

unless defined?(MESSAGE_ID)
  puts 'You need to set a MESSAGE_ID constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Generate a new OTP message using an email as recipient
  verify_message = client.verify_email_message(MESSAGE_ID)

  # Print the object information.
  puts
  puts 'The following information was returned as Verify Email Message object:'
  puts
  puts "  id                  : #{verify_message.id}"
  puts "  status              : #{verify_message.status}"
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
