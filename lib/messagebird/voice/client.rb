# frozen_string_literal: true

require 'net/https'
require 'uri'
require 'json'
require 'messagebird/http_client'

module MessageBird
  class VoiceClient < HttpClient
    ENDPOINT = 'https://voice.messagebird.com/'

    def endpoint
      ENDPOINT
    end

    def prepare_request(request, params = {})
      request['Content-Type'] = 'application/json'
      request.body = params.to_json
      request
    end
  end
end
