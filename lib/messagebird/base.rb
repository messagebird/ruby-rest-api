# frozen_string_literal: true

require 'json'
require 'time'

module MessageBird
  class Base
    def initialize(json)
      json.each do |k, v|
        m = k.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase # convert came case to snake case

        send("#{m}=", v) if respond_to?(:"#{m}=")
      end
    end

    def value_to_time(value)
      value ? Time.parse(value) : nil
    end
  end
end
