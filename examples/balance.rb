#!/usr/bin/env ruby
# frozen_string_literal: true

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib/")
require "messagebird"

ACCESS_KEY = "test_gshuPaZoeEG6ovbc8M79w0QyM"

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client  = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the Balance object.
  balance = client.balance

  # Print the object information.
  puts
  puts "The following information was returned as a Balance object:"
  puts
  puts "  payment : #{balance.payment}"
  puts "  type    : #{balance.type}"
  puts "  amount  : #{balance.amount}"
  puts

rescue MessageBird::ErrorException => ex
  puts
  puts "An error occured while requesting a Balance object:"
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
