require 'net/https'
require 'uri'
require 'json'
require 'messagebird/http_client'

module MessageBird
  class ConversationClient < HttpClient
    attr_reader :endpoint

    @endpoint  = 'https://conversations.messagebird.com/v1/'
    WHATSAPP_SANDBOX_ENDPOINT = 'https://whatsapp-sandbox.messagebird.com/v1/'

    def initialize(access_key, features=[])
      super(access_key)
      if features.include? Client::ENABLE_CONVERSATIONS_WHATSAPP_SANDBOX then
        @endpoint = WHATSAPP_SANDBOX_ENDPOINT
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
