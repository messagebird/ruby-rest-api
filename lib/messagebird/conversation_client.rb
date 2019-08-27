require 'net/https'
require 'uri'
require 'json'
require 'messagebird/http_client'

module MessageBird
  class ConversationClient < HttpClient
    attr_reader :endpoint

    BASE_ENDPOINT = 'https://conversations.messagebird.com/v1/'
    WHATSAPP_SANDBOX_ENDPOINT = 'https://whatsapp-sandbox.messagebird.com/v1/'

    def initialize(access_key)
      super(access_key)
      @endpoint  = BASE_ENDPOINT
    end

    def enable_feature(feature) 
      # To access the WhatsApp sandbox the endpoint changes to a proxy that emulates the real API to allow for easier testing of WhatsApp channels.
      if feature == Client::CONVERSATIONS_WHATSAPP_SANDBOX_FEATURE then
        @endpoint = WHATSAPP_SANDBOX_ENDPOINT
      end
    end

    def disable_feature() 
      # When the feature gets disabled the endpoint changes back to the live endpoint.
      if feature == Client::CONVERSATIONS_WHATSAPP_SANDBOX_FEATURE then
        @endpoint = BASE_ENDPOINT
      end
    end
    
    def endpoint() 
      @endpoint
    end

    def prepare_request(request, params={})
      request['Content-Type'] = 'application/json'
      request.body = params.to_json
      request
    end
  end
end
