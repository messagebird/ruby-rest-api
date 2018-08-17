require 'net/https'
require 'uri'

module MessageBird

  class InvalidPhoneNumberException < TypeError; end
  class MethodNotAllowedException < ArgumentError; end

  class HttpClient

    attr_reader :access_key

    def initialize(access_key)
      @access_key = access_key
    end

    def request(method, path, params={})
      uri = URI.join(ENDPOINT, '/', path)

      # Set up the HTTP object.
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl     = true

      request = prepare_request(method, uri, params)

      # Execute the request and fetch the response.
      response = http.request(request)

      # Parse the HTTP response.
      case response.code.to_i
      when 200, 201, 204, 401, 404, 405, 422
        # Ok
      else
        raise InvalidPhoneNumberException, 'Unknown response from server'
      end

      response.body
    end

    def prepare_request(method, uri, params={})
      # Construct the HTTP request.
      case method
      when :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      when :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when :post
        request = Net::HTTP::Post.new(uri.request_uri)
      else
        raise MethodNotAllowedException
      end

      request['Accept']        = 'application/json'
      request['Authorization'] = "AccessKey #{@access_key}"
      request['User-Agent']    = "MessageBird/ApiClient/#{CLIENT_VERSION} Ruby/#{RUBY_VERSION}"

      request.set_form_data(params) if method == :post && !params.empty?

      request
    end

  end

end