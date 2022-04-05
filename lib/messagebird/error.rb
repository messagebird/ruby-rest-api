# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class Error < MessageBird::Base
    attr_accessor :code, :description, :parameter

    def message
      if parameter
        "#{description} (error code: #{code}, parameter: #{parameter})"
      else
        "#{description} (error code: #{code})"
      end
    end
  end
end
