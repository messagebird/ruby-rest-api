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

  # Generate a new OTP message using an email as recipient
  otp = client.verify_create('Recipient Name <recipient.email@example.com>', # RECIPIENT EMAIL HERE
                             originator: 'sender@example.com', # SENDER EMAIL HERE
                             type: 'email',
                             subject: 'Your Verify test token',
                             template: '%token - Use this code to validate your Verify token.',
                             reference: 'MessageBirdReference')

  # Print the object information.
  puts
  puts 'The following information was returned as an OTP object:'
  puts
  puts "  id                  : #{otp.id}"
  puts "  href                : #{otp.href}"
  puts "  recipient           : #{otp.recipient}"
  puts "  reference           : #{otp.reference}"
  puts "  messages            : #{otp.messages}"
  puts "  status              : #{otp.status}"
  puts "  createdDatetime     : #{otp.created_datetime}"
  puts "  validUntilDatetime  : #{otp.valid_until_datetime}"
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
