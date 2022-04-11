# frozen_string_literal: true

require 'base64'
require 'digest'
require 'time'
require 'jwt'

module MessageBird
  class ValidationError < StandardError
  end

  ##
  # RequestValidator validates request signature signed by MessageBird services.
  #
  # @see https://developers.messagebird.com/docs/verify-http-requests
  class RequestValidator
    ALLOWED_ALGOS = %w[HS256 HS384 HS512].freeze

    ##
    #
    # @param [string] signature_key customer signature key. Can be retrieved through <a href="https://dashboard.messagebird.com/developers/settings">Developer Settings</a>. This is NOT your API key.
    # @param [bool] skip_url_validation whether url_hash claim validation should be skipped. Note that when true, no query parameters should be trusted.
    def initialize(signature_key, skip_url_validation: false)
      @signature_key = signature_key
      @skip_url_validation = skip_url_validation
    end

    ##
    # This method validates provided request signature, which is a JWT token.
    # This JWT is signed with a MessageBird account unique secret key, ensuring the request is from MessageBird and a specific account.
    # The JWT contains the following claims:
    #      *   "url_hash" - the raw URL hashed with SHA256 ensuring the URL wasn't altered.
    #      *    "payload_hash" - the raw payload hashed with SHA256 ensuring the payload wasn't altered.
    #      *    "jti" - a unique token ID to implement an optional non-replay check (NOT validated by default).
    #      *    "nbf" - the not before timestamp.
    #      *    "exp" - the expiration timestamp is ensuring that a request isn't captured and used at a later time.
    #      *    "iss" - the issuer name, always MessageBird.
    # @param [String] signature the actual signature taken from request header "MessageBird-Signature-JWT".
    # @param [String] url the raw url including the protocol, hostname and query string, e.g. "https://example.com/?example=42".
    # @param [Array] request_body the raw request body.
    # @return [Array] raw signature payload
    # @raise [ValidationError] if signature is invalid
    # @see https://developers.messagebird.com/docs/verify-http-requests
    def validate_signature(signature, url, request_body)
      raise ValidationError, 'Signature can not be empty' if signature.to_s.empty?
      raise ValidationError, 'URL can not be empty' if !@skip_url_validation && url.to_s.empty?

      claims = decode_signature signature
      validate_url(url, claims['url_hash']) unless @skip_url_validation
      validate_payload(request_body, claims['payload_hash'])

      claims
    end

    private # Applies to every method below this line

    def decode_signature(signature)
      begin
        claims, * = JWT.decode signature, @signature_key, true,
                               algorithm: ALLOWED_ALGOS,
                               iss: 'MessageBird',
                               required_claims: %w[iss nbf exp],
                               verify_iss: true,
                               leeway: 1
      rescue JWT::DecodeError => e
        raise ValidationError, e
      end

      claims
    end

    def validate_url(url, url_hash)
      expected_url_hash = Digest::SHA256.hexdigest url
      unless JWT::SecurityUtils.secure_compare(expected_url_hash, url_hash)
        raise ValidationError, 'invalid jwt: claim url_hash is invalid'
      end
    end

    def validate_payload(body, payload_hash)
      if !body.to_s.empty? && !payload_hash.to_s.empty?
        unless JWT::SecurityUtils.secure_compare(Digest::SHA256.hexdigest(body), payload_hash)
          raise ValidationError, 'invalid jwt: claim payload_hash is invalid'
        end
      elsif !body.to_s.empty?
        raise ValidationError, 'invalid jwt: claim payload_hash is not set but payload is present'
      elsif !payload_hash.to_s.empty?
        raise ValidationError, 'invalid jwt: claim payload_hash is set but actual payload is missing'
      end
    end
  end
end
