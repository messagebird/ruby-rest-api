#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'messagebird'
require 'time'

SIGNING_KEY = 'PlLrKaqvZNRR5zAjm42ZT6q1SQxgbbGd'

begin
  query = {
      'recipient' => '31612345678',
      'reference' => 'FOO',
      'statusDatetime' => '2019-01-11T09:17:11+00:00',
      'id' => 'eef0ab57a9e049be946f3821568c2b2e',
      'status' => 'delivered',
      'mccmnc' => '20408',
      'ported' => '1'
  }
  signature = 'KVBdcVdz2lYMwcBLZCRITgxUfA/WkwSi+T3Wxl2HL6w='
  requestTimestamp = 1547198231
  body = ''

  # Create a MessageBird signed request.
  signedRequest = MessageBird::SignedRequest.new(query, signature, requestTimestamp, body)

  # Verify the signed request.
  if signedRequest.verify(SIGNING_KEY)
    puts "The signed request has been verified."
  else
    puts "The signed request cannot be verified."
  end

  # Check recentness of the signed request.
  if signedRequest.isRecent()
    puts "The signed request is recent."
  else
    puts "The signed request is not recent."
  end

rescue MessageBird::ValidationException => ex
  puts
  puts 'An error occurred while verifying the signed request:'
  puts ex
end
