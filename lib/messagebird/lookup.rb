# frozen_string_literal: true

require 'time'

require 'messagebird/base'

module MessageBird
  class Lookup < MessageBird::Base
    attr_accessor :href, :country_code, :countryPrefix, :phoneNumber, :type
    attr_reader :formats, :hlr

    def formats=(new_formats)
      @formats = Formats.new(new_formats)
    end

    def hlr=(new_hlr)
      @hlr = HLR.new(new_hlr)
    end
  end

  class Formats < MessageBird::Base
    attr_accessor :e164, :international, :national, :rfc3966
  end
end
