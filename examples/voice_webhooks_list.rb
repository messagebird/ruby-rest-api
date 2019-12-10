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

  # Fetch the Webhooks list
  # page start from 1
  page = 1
  per_page = 10
  webhooks = client.voice_webhooks_list(per_page, page)

  # Print the object information.
  puts 'The following information was returned as a Webhooks list:'
  puts
  puts "  pageCount       : #{webhooks.page_count}"
  puts "  currentPage     : #{webhooks.current_page}"
  puts "  perPage         : #{webhooks.per_page}"
  puts "  totalCount      : #{webhooks.total_count}"
  puts
  webhooks.items.each do |webhook|
    puts 'Webhook:'
    puts "  id                        : #{webhook.id}"
    puts "  url                       : #{webhook.url}"
    puts "  status                    : #{webhook.token}"
    puts "  createdAt                 : #{webhook.created_at}"
    puts "  updatedAt                 : #{webhook.updated_at}"
  end
rescue MessageBird::ErrorException => e
  puts
  puts 'An error occured while creating a voice:'
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
