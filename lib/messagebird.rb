libdir = File.dirname(__FILE__)
$:.unshift(libdir) unless $:.include?(libdir)

module MessageBird
  CLIENT_VERSION          = '1.4.2'
  ENDPOINT                = 'https://rest.messagebird.com/'
  CONVERSATIONS_ENDPOINT  = 'https://conversations.messagebird.com/v1/'

  CONVERSATION_STATUS_ACTIVE   = 'active'
  CONVERSATION_STATUS_ARCHIVED = 'archived'

end

require 'messagebird/balance'
require 'messagebird/client'
require 'messagebird/contact'
require 'messagebird/error'
require 'messagebird/group_reference'
require 'messagebird/hlr'
require 'messagebird/http_client'
require 'messagebird/message_reference'
require 'messagebird/signed_request'
require 'messagebird/verify'
require 'messagebird/message'
require 'messagebird/voicemessage'
