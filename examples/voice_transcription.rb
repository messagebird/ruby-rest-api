#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

ACCESS_KEY = '5GN0YnOqM9QZyaTgB1Q2qUNsK'

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Start a conversation
  calls = client.call_list(10, 0)
  call_id = calls[0].id
  legs = client.call_leg_list(call_id)
  legs.items.each do |leg|
    recordings = client.call_leg_recording_list(call_id, leg.id)
    recordings.items.each do |recording|
      transcriptions = client.voice_transcriptions_list(call_id, leg.id, recording.id)
      transcriptions.items.each do |transcription|
        puts  '    --------------------------------------------------'
        puts  "    transcription ID   : #{transcription.id}"
        puts  "    recording ID       : #{transcription.recordingId}"
        puts  "    createdAt          : #{transcription.createdAt}"
        puts  "    updatedAt          : #{transcription.updatedAt}"
        puts  "    links              : #{transcription._links}"
        client.voice_transcription_download(call_id, leg.id, recording.id, transcription.id) do |response|
          puts "    transcription       : #{response.body}"
        end
      end
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
