#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'

# ACCESS_KEY = ''

unless defined?(ACCESS_KEY)
  puts 'You need to set an ACCESS_KEY constant in this file'
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Create a webhook
  webhook = client.voice_webhook_update('00000000000000000000', url: 'https://other.com', token: 'othertoken')

  # Print the object information.
  puts 'Webhook:'
  puts "  id                        : #{webhook.id}"
  puts "  url                       : #{webhook.url}"
  puts "  status                    : #{webhook.token}"
  puts "  createdAt                 : #{webhook.createdAt}"
  puts "  updatedAt                 : #{webhook.updatedAt}"
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while updating a voice webhook:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
