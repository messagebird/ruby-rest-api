#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib/")
require 'messagebird'

ACCESS_KEY = 'test_gshuPaZoeEG6ovbc8M79w0QyM'

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Send a new voice message.
  vmsg = client.voice_message_create('31612345678', 'Hello World', reference: 'Foobar')

  # Print the object information.
  puts
  puts 'The following information was returned as a VoiceMessage object:'
  puts
  puts "  id                  : #{vmsg.id}"
  puts "  href                : #{vmsg.href}"
  puts "  originator          : #{vmsg.originator}"
  puts "  body                : #{vmsg.body}"
  puts "  reference           : #{vmsg.reference}"
  puts "  language            : #{vmsg.language}"
  puts "  voice               : #{vmsg.voice}"
  puts "  repeat              : #{vmsg.repeat}"
  puts "  ifMachine           : #{vmsg.if_machine}"
  puts "  scheduledDateTime   : #{vmsg.scheduled_date_time}"
  puts "  createdDatetime     : #{vmsg.created_datetime}"
  puts "  recipients          : #{vmsg.recipients}"
  puts
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while requesting an VoiceMessage object:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
