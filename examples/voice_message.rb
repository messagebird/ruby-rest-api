#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

# ACCESS_KEY = ''
# MESSAGE_ID = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

unless defined?(MESSAGE_ID)
  puts 'You need to set an MESSAGE_ID constant in this file'
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
  puts "  body              : #{vmsg.body}"
  puts "  reference         : #{vmsg.reference}"
  puts "  language          : #{vmsg.language}"
  puts "  voice             : #{vmsg.voice}"
  puts "  repeat            : #{vmsg.repeat}"
  puts "  ifMachine         : #{vmsg.ifMachine}"
  puts "  scheduledDatetime : #{vmsg.scheduledDatetime}"
  puts "  createdDatetime   : #{vmsg.createdDatetime}"
  puts "  recipients        : #{vmsg.recipients}"
  puts

rescue MessageBird::ErrorException => ex
  puts
  puts 'An error occured while requesting an VoiceMessage object:'
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
