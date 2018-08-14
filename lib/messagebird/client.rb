require 'json'
require 'net/https'
require 'uri'

require 'messagebird/balance'
require 'messagebird/error'
require 'messagebird/hlr'
require 'messagebird/http_client'
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

  class Client

    attr_reader :access_key
    attr_reader :http_client

    def initialize(access_key = nil, http_client = nil)
      @access_key = access_key || ENV['MESSAGEBIRD_ACCESS_KEY']
      @http_client = http_client || HttpClient.new(@access_key)
    end

    def request(method, path, params={})
      response_body = @http_client.request(method, path, params)
      json = JSON.parse(response_body)

      # If the request returned errors, create Error objects and raise.
      if json.has_key?('errors')
        raise ErrorException, json['errors'].map { |e| Error.new(e) }
      end

      json
    end

    # Retrieve your balance.
    def balance
      Balance.new(request(:get, 'balance'))
    end

    # Retrieve the information of specific HLR.
    def hlr(id)
      HLR.new(request(:get, "hlr/#{id.to_s}"))
    end

    # Create a new HLR.
    def hlr_create(msisdn, reference)
      HLR.new(request(
        :post,
        'hlr',
        :msisdn    => msisdn,
        :reference => reference))
    end

    # Retrieve the information of specific Verify.
    def verify(id)
      Verify.new(request(:get, "verify/#{id.to_s}"))
    end

    # Generate a new One-Time-Password message.
    def verify_create(recipient, params={})
      Verify.new(request(
          :post,
          'verify',
          params.merge({
              :recipient => recipient
          })
      ))
    end

    # Verify the One-Time-Password.
    def verify_token(id, token)
      Verify.new(request(:get, "verify/#{id.to_s}?token=#{token}"))
    end

    # Delete a Verify
    def verify_delete(id)
      Verify.new(request(:delete, "verify/#{id.to_s}"))
    end

    # Retrieve the information of specific message.
    def message(id)
      Message.new(request(:get, "messages/#{id.to_s}"))
    end

    # Create a new message.
    def message_create(originator, recipients, body, params={})
      # Convert an array of recipients to a comma-separated string.
      recipients = recipients.join(',') if recipients.kind_of?(Array)

      Message.new(request(
        :post,
        'messages',
        params.merge({
          :originator => originator.to_s,
          :body       => body.to_s,
          :recipients => recipients })))
    end

    # Retrieve the information of a specific voice message.
    def voice_message(id)
      VoiceMessage.new(request(:get, "voicemessages/#{id.to_s}"))
    end

    # Create a new voice message.
    def voice_message_create(recipients, body, params={})
      # Convert an array of recipients to a comma-separated string.
      recipients = recipients.join(',') if recipients.kind_of?(Array)

      VoiceMessage.new(request(
        :post,
        'voicemessages',
        params.merge({ :recipients => recipients, :body => body.to_s })))
    end

    def lookup(phoneNumber, params={})
      Lookup.new(request(:get, "lookup/#{phoneNumber}", params))
    end

    def lookup_hlr_create(phoneNumber, params={})
      HLR.new(request(:post, "lookup/#{phoneNumber}/hlr", params))
    end

    def lookup_hlr(phoneNumber, params={})
      HLR.new(request(:get, "lookup/#{phoneNumber}/hlr", params))
    end

  end
end
