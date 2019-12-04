#!/usr/bin/env ruby
# frozen_string_literal: true

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib/")
require "messagebird"

ACCESS_KEY = "YOUR KEY HERE"

unless defined?(ACCESS_KEY)
  puts "You need to set an ACCESS_KEY constant in this file"
  exit 1
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the Contact list with pagination options (skip the first 5 objects and take 10).
  limit = 10
  offset = 5
  contacts = client.contact_list(limit, offset)

  # Print the object information.
  puts
  puts "The following information was returned as a Contact list:"
  puts
  puts "  count           : #{contacts.count}"
  puts "  limit           : #{contacts.limit}"
  puts "  offset          : #{contacts.offset}"
  puts "  totalCount      : #{contacts.totalCount}"
  puts "  links           : #{contacts.links}"

  unless contacts.items.empty?
    contact = contacts[0] # Equivalent to contacts.items[0]

    puts "  Contact             :"
    puts "    id              : #{contact.id}"
    puts "    href            : #{contact.href}"
    puts "    msisdn          : #{contact.msisdn}"
    puts "    firstName       : #{contact.firstName}"
    puts "    lastName        : #{contact.lastName}"
    puts "    groups          : #{contact.groups.href}" # contact.groups.totalCount is also available.
    puts "    messages        : #{contact.messages.href}" # contact.messages.totalCount is also available.
    puts "    custom1         : #{contact.custom_details.custom1}"
    puts "    custom2         : #{contact.custom_details.custom2}"
    puts "    custom3         : #{contact.custom_details.custom3}"
    puts "    custom4         : #{contact.custom_details.custom4}"

  end

rescue MessageBird::ErrorException => e
  puts
  puts "An error occurred while listing your contacts:"
  puts

  e.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
