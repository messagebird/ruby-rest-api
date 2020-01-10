#!/usr/bin/env ruby

# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

ACCESS_KEY = 'YOUR KEY HERE'
CALL_ID    = 'YOUR CALL ID HERE'

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Request the legs (overview of inbound/outbound portions of this call)
  puts "Retrieving legs for call #{CALL_ID}"
  legs = client.call_leg_list(CALL_ID)

  legs.items.each do |leg|
    puts "  Retrieving recordings for leg #{leg.id}"
    recordings = client.call_leg_recording_list(CALL_ID, leg.id)

    recordings.items.each do |recording|
      client.call_leg_recording_view(CALL_ID, leg.id, recording.id)

      puts  '    --------------------------------------------------'
      puts  "    recording ID   : #{recording.id}"
      puts  "    recording URI  : #{recording.uri}"
      print '    downloading    : '
      client.call_leg_recording_download(recording.uri) do |response|
        File.open("#{recording.id}.wav", 'w') do |io|
          response.read_body do |chunk|
            putc '.'
            io.write(chunk)
          end
        end
      end
      puts ' DONE!'
      puts
    end
  end
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while listing the calls:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
