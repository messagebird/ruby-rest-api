#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
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
  puts "The following information was returned as a Webhooks list:"
  puts
  puts "  pageCount       : #{webhooks.pageCount}"
  puts "  currentPage     : #{webhooks.currentPage}"
  puts "  perPage         : #{webhooks.perPage}"
  puts "  totalCount      : #{webhooks.totalCount}"
  puts 
  webhooks.items.each do |webhook|
     puts "Webhook:"
     puts "  id                        : #{webhook.id}"
     puts "  url                       : #{webhook.url}"
     puts "  status                    : #{webhook.token}"
     puts "  createdAt                 : #{webhook.createdAt}"
     puts "  updatedAt                 : #{webhook.updatedAt}"
  end 

rescue MessageBird::ErrorException => ex
  puts
  puts 'An error occured while creating a voice:'
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
