# frozen_string_literal: true

require 'json'
require 'time'

module MessageBird
  class Base
    # takes each element from the given hash and apply it to ourselves through an assignment method
    def map_hash_elements_to_self(hash)
      return if hash.nil?

      hash.each do |key, value|
        method_name = key.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase # convert came case to snake case
        method_name += '='
        send(method_name, value) if respond_to?(method_name)
      end
    end

    def initialize(json)
      map_hash_elements_to_self(json)
    end

    def value_to_time(value)
      value ? Time.parse(value) : nil
    end
  end
end
