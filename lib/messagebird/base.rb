# frozen_string_literal: true

require "json"
require "time"

module MessageBird
  class Base
    def initialize(json)
      json.each do |k, v|
        if respond_to?(:"#{k}=")
          send("#{k}=", v)
        end
      end
    end

    def value_to_time(value)
      value ? Time.parse(value) : nil
    end
  end
end
