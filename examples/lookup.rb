#!/usr/bin/env ruby
# frozen_string_literal: true

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib/")
require "messagebird"

# ACCESS_KEY = 'YOUR KEY HERE'
# PHONE_NUMBER = '+31612345678'

unless defined?(ACCESS_KEY)
  puts "You need to set an ACCESS_KEY constant in this file"
  exit 1
end

unless defined?(PHONE_NUMBER)
  puts "You need to set an PHONE_NUMBER constant in this file"
end

begin
  # Create a MessageBird client with the specified ACCESS_KEY.
  client = MessageBird::Client.new(ACCESS_KEY)

  # Fetch the HLR object for the specified HLR_ID.
  lookup = client.lookup(PHONE_NUMBER)

  # Print the object information.
  puts
  puts "The following information was returned as an HLR object:"
  puts
  puts "  href            : #{lookup.href}"
  puts "  countryCode     : #{lookup.countryCode}"
  puts "  countryPrefix   : #{lookup.countryPrefix}"
  puts "  phoneNumber     : #{lookup.phoneNumber}"
  puts "  type            : #{lookup.type}"

  puts "  formats         :"
  puts "    e164          : #{lookup.formats.e164}"
  puts "    international : #{lookup.formats.international}"
  puts "    national      : #{lookup.formats.national}"
  puts "    rfc3966       : #{lookup.formats.rfc3966}"

  unless lookup.hlr.nil?
    puts "  hlr             :"
    puts "    id              : #{lookup.hlr.id}"
    puts "    href            : #{lookup.hlr.href}"
    puts "    msisdn          : #{lookup.hlr.msisdn}"
    puts "    reference       : #{lookup.hlr.reference}"
    puts "    status          : #{lookup.hlr.status}"
    puts "    createdDatetime : #{lookup.hlr.createdDatetime}"
    puts "    statusDatetime  : #{lookup.hlr.statusDatetime}"
  end

rescue MessageBird::ErrorException => ex
  puts
  puts "An error occured while requesting the lookup:"
  puts

  ex.errors.each do |error|
    puts "  code        : #{error.code}"
    puts "  description : #{error.description}"
    puts "  parameter   : #{error.parameter}"
    puts
  end
end
