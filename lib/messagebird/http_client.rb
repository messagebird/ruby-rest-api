# frozen_string_literal: true

require 'net/https'
require 'uri'

module MessageBird
  class InvalidPhoneNumberException < TypeError; end
  class InvalidResponseException < StandardError; end
  class MethodNotAllowedException < ArgumentError; end

  class HttpClient
    attr_reader :access_key

    ENDPOINT = 'https://rest.messagebird.com/'.freeze

    def initialize(access_key)
      @access_key = access_key
    end

    def endpoint
      ENDPOINT
    end

    def build_http_client(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      http.set_debug_output($stdout) unless ENV['DEBUG_MB_HTTP_CLIENT'].nil?

      http
    end

    def request(method, path, params = {}, check_json = true)
      uri     = URI.join(endpoint, path)
      http    = build_http_client(uri)
      request = build_request(method, uri, params)

      # Execute the request and fetch the response.
      response = http.request(request)

      assert_valid_response_code(response.code.to_i)
      assert_json_response_type(response['Content-Type']) unless check_json

      response.body
    end

    def request_block(method, path, params = {})
      uri     = URI.join(endpoint, path)
      http    = build_http_client(uri)
      request = build_request(method, uri, params)

      http.request(request, &Proc.new)
    end

    def prepare_request(request, params = {})
      request.set_form_data(params)

      request
    end

    SUBMIT_METHODS = [:patch, :post, :put].freeze

    def build_request(method, uri, params = {})
      # Construct the HTTP request.
      raise MethodNotAllowedException unless [:delete, :get, :patch, :post].include?(method)

      request = "Net::HTTP::#{method.to_s.capitalize}".constantize.new(uri.request_uri)

      request['Accept']        = 'application/json'
      request['Authorization'] = "AccessKey #{@access_key}"
      request['User-Agent']    = "MessageBird/ApiClient/#{Version::STRING} Ruby/#{RUBY_VERSION}"

      if SUBMIT_METHODS.include?(method) && !params.empty?
        prepare_request(request, params)
      end

      request
    end

    # Throw an exception if the response code is not one we expect from the
    # MessageBird API.
    def assert_valid_response_code(code)
      # InvalidPhoneNumberException does not make a lot of sense here, but it's
      # needed to maintain backwards compatibility. See issue:
      # https://github.com/messagebird/ruby-rest-api/issues/17
      expected_codes = [200, 201, 202, 204, 401, 404, 405, 422]

      raise InvalidPhoneNumberException, 'Unknown response from server' unless expected_codes.include? code
    end

    # Throw an exception if the response's content type is not JSON. This only
    # checks the header: it doesn't inspect the actual body.
    def assert_json_response_type(content_type)
      # Check whether the header starts with application/json and don't check
      # for equality: some API's may append the charset to this header.
      raise InvalidResponseException, 'Response is not JSON' unless content_type.start_with? 'application/json'
    end
  end
end
