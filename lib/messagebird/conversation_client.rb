require 'net/https'
require 'uri'
require 'json'

module MessageBird
  class ConversationClient < HttpClient
    def endpoint() 
      CONVERSATIONS_ENDPOINT
    end

    def prepare_request(request, params={})
      request.body = params.to_json
      request
    end
  end
end
