require 'active_support/all'
require 'digest'
require 'time'

module MessageBird
  class ValidationException < TypeError;
  end

  class SignedRequest
    def initialize(queryParameters, signature, requestTimestamp, body)

      if !queryParameters.is_a? Hash
        raise ValidationException, 'The "queryParameters" value is invalid.'
      end
      if !signature.is_a? String
        raise ValidationException, 'The "signature" value is invalid.'
      end
      if !requestTimestamp.is_a? Integer
        raise ValidationException, 'The "requestTimestamp" value is invalid.'
      end
      if !body.is_a? String
        raise ValidationException, 'The "body" value is invalid.'
      end

      @queryParameters, @signature, @requestTimestamp, @body = queryParameters, signature, requestTimestamp, body
    end

    def verify(signingKey)
      calculatedSignature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signingKey, buildPayload)
      expectedSignature = Base64.decode64(@signature)
      secure_compare(calculatedSignature, expectedSignature)
    end

    def buildPayload
      parts = []
      parts.push(@requestTimestamp)
      parts.push(@queryParameters.sort.to_h.to_query)
      parts.push(Digest::SHA256.new.digest @body)
      parts.join("\n")
    end

    def isRecent(offset = 10)
      (Time.now.getutc.to_i - @requestTimestamp) < offset;
    end

    def secure_compare(a, b)
      return false if a.empty? || b.empty? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte {|byte| res |= byte ^ l.shift}
      res == 0
    end
  end
end
