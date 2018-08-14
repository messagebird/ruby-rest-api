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

      # Construct the HTTP GET or POST request.
      case method
      when :get
        request = Net::HTTP::Get.new(uri.request_uri)  if method == :get
      when :post
        request = Net::HTTP::Post.new(uri.request_uri) if method == :post
      else
        raise MethodNotAllowedException
      end

      request['Accept']        = 'application/json'
      request['Authorization'] = "AccessKey #{@access_key}"
      request['User-Agent']    = "MessageBird/ApiClient/#{CLIENT_VERSION} Ruby/#{RUBY_VERSION}"

      # If present, add the HTTP POST parameters.
      request.set_form_data(params) if method == :post && !params.empty?

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

  end

end