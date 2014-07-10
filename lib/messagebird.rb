libdir = File.dirname(__FILE__)
$:.unshift(libdir) unless $:.include?(libdir)

module MessageBird
  CLIENT_VERSION = '1.1.0'
  ENDPOINT       = 'https://rest.messagebird.com'
end

require 'messagebird/balance'
require 'messagebird/client'
require 'messagebird/error'
require 'messagebird/hlr'
require 'messagebird/message'
require 'messagebird/voicemessage'
