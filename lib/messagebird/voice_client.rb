require 'net/https'
require 'uri'
require 'json'
require 'messagebird/http_client'

module MessageBird
  class VoiceClient < HttpClient
    attr_reader :endpoint

    BASE_ENDPOINT = 'https://voice.messagebird.com/'

    def initialize(access_key)
      super(access_key)
      @endpoint  = BASE_ENDPOINT
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
