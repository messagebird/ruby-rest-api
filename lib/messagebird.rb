# frozen_string_literal: true

libdir = File.dirname(__FILE__)
$:.unshift(libdir) unless $:.include?(libdir)

module MessageBird
  CLIENT_VERSION          = "2.0.0-rc"
end

require "messagebird/balance"
require "messagebird/client"
require "messagebird/contact"
require "messagebird/error"
require "messagebird/group_reference"
require "messagebird/hlr"
require "messagebird/http_client"
require "messagebird/message_reference"
require "messagebird/signed_request"
require "messagebird/verify"
require "messagebird/message"
require "messagebird/voicemessage"
require "messagebird/call"
