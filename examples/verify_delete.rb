#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

# ACCESS_KEY = ''
# VERIFY_ID = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

unless defined?(VERIFY_ID)
    puts 'You need to set a VERIFY_ID constant in this file'
    exit 1
  end

begin
    # Create a MessageBird client with the specified ACCESS_KEY.
    client = MessageBird::Client.new(ACCESS_KEY)
  
    # Delete the verify
    client.verify_delete(VERIFY_ID)
  
    # Print the object information.
    puts
    puts 'Success. The delete method has empty return.'
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