#!/usr/bin/env ruby
# frozen_string_literal: true

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib/")
require "messagebird"

# ACCESS_KEY = ''
# MESSAGE_ID = ''

unless defined?(ACCESS_KEY)
  puts "You need to set an ACCESS_KEY constant in this file"
  exit 1
end

unless defined?(MESSAGE_ID)
  puts "You need to set an MESSAGE_ID constant in this file"
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the VoiceMessage object for the specified MESSAGE_ID.
  vmsg = client.voice_message(MESSAGE_ID)

  # Print the object information.
  puts
  puts "The following information was returned as a VoiceMessage object:"
  puts
  puts "  id                : #{vmsg.id}"
  puts "  href              : #{vmsg.href}"
  puts "  originator        : #{vmsg.originator}"
  puts "  body              : #{vmsg.body}"
  puts "  reference         : #{vmsg.reference}"
  puts "  language          : #{vmsg.language}"
  puts "  voice             : #{vmsg.voice}"
  puts "  repeat            : #{vmsg.repeat}"
  puts "  ifMachine         : #{vmsg.ifMachine}"
  puts "  scheduled_date_time : #{vmsg.scheduled_date_time}"
  puts "  created_datetime   : #{vmsg.created_datetime}"
  puts "  recipients        : #{vmsg.recipients}"
  puts

rescue MessageBird::ErrorException => e
  puts
  puts "An error occured while requesting an VoiceMessage object:"
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
