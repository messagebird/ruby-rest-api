#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib/")
require 'messagebird'

SIGNING_KEY = 'PlLrKaqvZNRR5zAjm42ZT6q1SQxgbbGd'

url = 'https://FULL_REQUEST_URL/path?query=1'
signature = 'YOUR_REQUEST_SIGNATURE'
body = ''

request_validator = MessageBird::RequestValidator.new(SIGNING_KEY)

begin
  # Verify the signed request.
  request_validator.validate_signature(signature, url, body.bytes.to_a)
rescue MessageBird::ValidationError => e
  puts
  puts 'An error occurred while verifying the signed request:'
  puts e
end
