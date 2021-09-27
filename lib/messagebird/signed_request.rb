# frozen_string_literal: true

require 'base64'
require 'digest'
require 'time'

module MessageBird
  ##
  # @deprecated Use {MessageBird::RequestValidator::ValidationError} instead.
  class ValidationException < TypeError
  end

  ##
  # @deprecated Use {MessageBird::RequestValidator} instead.
  class SignedRequest
    ##
    # @deprecated Use {MessageBird::RequestValidator} instead.
    def initialize(query_parameters, signature, request_timestamp, body)
      unless query_parameters.is_a? Hash
        raise ValidationException, 'The "query_parameters" value is invalid.'
      end
      unless signature.is_a? String
        raise ValidationException, 'The "signature" value is invalid.'
      end
      unless request_timestamp.is_a? Integer
        raise ValidationException, 'The "request_timestamp" value is invalid.'
      end
      unless body.is_a? String
        raise ValidationException, 'The "body" value is invalid.'
      end

      @query_parameters = query_parameters
      @signature = signature
      @request_timestamp = request_timestamp
      @body = body
    end

    ##
    # @deprecated Use {MessageBird::RequestValidator::validateSignature} instead.
    def verify(signing_key)
      calculated_signature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signing_key, build_payload)
      expected_signature = Base64.decode64(@signature)
      calculated_signature.bytes == expected_signature.bytes
    end

    ##
    # @deprecated Use {MessageBird::RequestValidator} instead.
    def build_payload
      parts = []
      parts.push(@request_timestamp)
      parts.push(URI.encode_www_form(@query_parameters.sort))
      parts.push(Digest::SHA256.new.digest(@body))
      parts.join("\n")
    end

    ##
    # @deprecated Use {MessageBird::RequestValidator} instead.
    def recent?(offset = 10)
      (Time.now.getutc.to_i - @request_timestamp) < offset
    end
  end
end
