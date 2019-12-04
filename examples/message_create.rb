#!/usr/bin/env ruby
# frozen_string_literal: true

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib/")
require "messagebird"

ACCESS_KEY = "test_gshuPaZoeEG6ovbc8M79w0QyM"

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Send a new message.
  msg = client.message_create("FromMe", "31612345678", "Hello World", reference: "Foobar")

  # Print the object information.
  puts
  puts "The following information was returned as a Message object:"
  puts
  puts "  id                : #{msg.id}"
  puts "  href              : #{msg.href}"
  puts "  direction         : #{msg.direction}"
  puts "  type              : #{msg.type}"
  puts "  originator        : #{msg.originator}"
  puts "  body              : #{msg.body}"
  puts "  reference         : #{msg.reference}"
  puts "  validity          : #{msg.validity}"
  puts "  gateway           : #{msg.gateway}"
  puts "  typeDetails       : #{msg.typeDetails}"
  puts "  datacoding        : #{msg.datacoding}"
  puts "  mclass            : #{msg.mclass}"
  puts "  scheduled_date_time : #{msg.scheduled_date_time}"
  puts "  created_datetime   : #{msg.created_datetime}"
  puts "  recipients        : #{msg.recipients}"
  puts

rescue MessageBird::ErrorException => e
  puts
  puts "An error occured while requesting a Message object:"
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
