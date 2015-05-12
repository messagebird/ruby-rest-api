#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

ACCESS_KEY = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Verify an OTP message with a token
  otp = client.otp_verify(31612345678, 123456, {
      :reference => "MessageBirdReference"
  })

  # Print the object information.
  puts
  puts "The following information was returned as an OTP object:"
  puts
  puts "  id                  : #{otp.id}"
  puts "  recipient           : #{otp.recipient}"
  puts "  reference           : #{otp.reference}"
  puts "  status              : #{otp.status}"
  puts "  href                : #{otp.href}"
  puts "  createdDatetime     : #{otp.createdDatetime}"
  puts "  validUntilDatetime  : #{otp.validUntilDatetime}"
  puts

rescue MessageBird::ErrorException => ex
  puts
  puts 'An error occured while requesting an OTP object:'
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
