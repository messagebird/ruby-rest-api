libdir = File.dirname(__FILE__)
$:.unshift(libdir) unless $:.include?(libdir)

module MessageBird
  CLIENT_VERSION = '1.3.3'
  ENDPOINT       = 'https://rest.messagebird.com'
end

require 'messagebird/balance'
require 'messagebird/client'
require 'messagebird/contact'
require 'messagebird/error'
require 'messagebird/group_reference'
require 'messagebird/hlr'
require 'messagebird/http_client'
require 'messagebird/message_reference'
require 'messagebird/verify'
require 'messagebird/message'
require 'messagebird/voicemessage'
