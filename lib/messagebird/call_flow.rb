# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class CallFlow < MessageBird::Base
    attr_accessor :id, :title, :record, :default
    attr_reader :steps, :created_at, :updated_at

    def steps=(json)
      @steps = json.map { |s| MessageBird::CallFlowStep.new(s) }
    end

    def created_at=(value)
      @created_at = value_to_time(value)
    end

    def updated_at=(value)
      @updated_at = value_to_time(value)
    end
  end
end
