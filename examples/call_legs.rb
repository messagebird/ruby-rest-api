#!/usr/bin/env ruby

# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

ACCESS_KEY = 'YOUR ACCESS KEY HERE'
CALL_ID = 'YOUR CALL ID HERE'

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Start a conversation
  legs = client.call_leg_list(CALL_ID, 10, 0)

  legs.items.each do |leg_obj|
    puts "leg ID: #{leg_obj.id}"
    puts "  call ID       : #{leg_obj.callId}"
    puts "  source        : #{leg_obj.source}"
    puts "  destination   : #{leg_obj.destination}"
    puts "  status        : #{leg_obj.status}"
    puts "  direction     : #{leg_obj.direction}"
    puts "  cost          : #{leg_obj.cost}"
    puts "  currency      : #{leg_obj.currency}"
    puts "  duration      : #{leg_obj.duration}"
    puts "  createdAt     : #{leg_obj.created_at}"
    puts "  updatedAt     : #{leg_obj.updated_at}"
    puts "  answeredAt    : #{leg_obj.answeredAt}"
    puts "  endedAt       : #{leg_obj.endedAt}"
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
