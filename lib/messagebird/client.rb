require 'json'
require 'net/https'
require 'uri'

require 'messagebird/balance'
require 'messagebird/error'
require 'messagebird/hlr'
require 'messagebird/verify'
require 'messagebird/message'
require 'messagebird/voicemessage'
require 'messagebird/lookup'

module MessageBird
  class ErrorException < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end
  end

  class InvalidPhoneNumberException < TypeError; end

  class Client
    attr_reader :access_key

    def initialize(access_key = nil)
      @access_key = access_key || ENV['MESSAGEBIRD_ACCESS_KEY']
    end

    def request(method, path, params={})
      uri = URI.join(ENDPOINT, '/', path)
      uri.query = URI.encode_www_form(params) unless method::REQUEST_HAS_BODY || params.empty?

      # Set up the HTTP object.
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      # Construct the request.
      request = method.new(uri.request_uri)

      request['Accept']        = 'application/json'
      request['Authorization'] = "AccessKey #{@access_key}"
      request['User-Agent']    = "MessageBird/ApiClient/#{CLIENT_VERSION} Ruby/#{RUBY_VERSION}"

      request.set_form_data(params) if method::REQUEST_HAS_BODY

      # Execute the request and fetch the response.
      response = http.request(request)

      # Parse the HTTP response.
      case response.code.to_i
      when 200, 201, 204, 401, 404, 405, 422
        json = response.body.nil? ? {} : JSON.parse(response.body)
        return json unless json.has_key?('errors')

        # If the request returned errors, create Error objects and raise.
        raise ErrorException, json['errors'].map { |e| Error.new(e) }
      else
        raise Net::HTTPServerError.new response.http_version, 'Unknown response from server', response
      end
    end

    # Retrieve your balance.
    def balance
      Balance.new(request(GET, 'balance'))
    end

    # Retrieve the information of specific HLR.
    def hlr(id)
      HLR.new(request(GET, "hlr/#{id.to_s}"))
    end

    # Create a new HLR.
    def hlr_create(msisdn, reference)
      HLR.new(request(
        POST,
        'hlr',
        :msisdn    => msisdn,
        :reference => reference))
    end

    # Retrieve the information of specific Verify.
    def verify(id)
      Verify.new(request(GET, "verify/#{id.to_s}"))
    end

    # Generate a new One-Time-Password message.
    def verify_create(recipient, params={})
      Verify.new(request(
          POST,
          'verify',
          params.merge({
              :recipient => recipient
          })
      ))
    end

    # Verify the One-Time-Password.
    def verify_token(id, token)
      Verify.new(request(GET, "verify/#{id.to_s}?token=#{token}"))
    end

    # Delete a Verify
    def verify_delete(id)
      Verify.new(request(DELETE, "verify/#{id.to_s}"))
    end

    def messages(params = {})
      request(GET, 'messages', params).tap do |data|
        data['items'] = data['items'].map(&Message.method(:new))
      end
    end

    # Retrieve the information of specific message.
    def message(id)
      Message.new(request(GET, "messages/#{id.to_s}"))
    end

    # Create a new message.
    def message_create(originator, recipients, body, params={})
      # Convert an array of recipients to a comma-separated string.
      recipients = recipients.join(',') if recipients.kind_of?(Array)

      Message.new(request(
        POST,
        'messages',
        params.merge({
          :originator => originator.to_s,
          :body       => body.to_s,
          :recipients => recipients })))
    end

    # Delete a specific message.
    def message_delete(id)
      request(DELETE, "messages/#{id.to_s}")
    end

    # Retrieve the information of a specific voice message.
    def voice_message(id)
      VoiceMessage.new(request(GET, "voicemessages/#{id.to_s}"))
    end

    # Create a new voice message.
    def voice_message_create(recipients, body, params={})
      # Convert an array of recipients to a comma-separated string.
      recipients = recipients.join(',') if recipients.kind_of?(Array)

      VoiceMessage.new(request(
        POST,
        'voicemessages',
        params.merge({ :recipients => recipients, :body => body.to_s })))
    end

    def lookup(phoneNumber, params={})
      Lookup.new(request(GET, "lookup/#{phoneNumber}", params))
    end

    def lookup_hlr_create(phoneNumber, params={})
      HLR.new(request(POST, "lookup/#{phoneNumber}/hlr", params))
    end

    def lookup_hlr(phoneNumber, params={})
      HLR.new(request(GET, "lookup/#{phoneNumber}/hlr", params))
    end

    private

    GET = Net::HTTP::Get
    POST = Net::HTTP::Post
    DELETE = Net::HTTP::Delete
  end
end
