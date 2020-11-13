# frozen_string_literal: true

require 'net/https'
require 'uri'
require 'json'
require 'messagebird/http_client'

module MessageBird
  class ConversationClient < HttpClient
    ENDPOINT  = 'https://conversations.messagebird.com/v1/'

    def prepare_request(request, params = {})
      request['Content-Type'] = 'application/json'
      request.body = params.to_json
      request
    end

    def endpoint() 
      ENDPOINT
    end
  end
end
