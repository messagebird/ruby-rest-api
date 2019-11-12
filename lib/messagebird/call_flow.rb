require 'messagebird/base'

module MessageBird
  class CallFlow < MessageBird::Base
    attr_accessor :id, :title, :record, :steps, :default, :createdAt, :updatedAt

    def steps=(json)
      @steps = json.map { |s| MessageBird::CallFlowStep.new(s) }
    end

    def createdAt=(value)
      @createdAt = value_to_time(value)
    end

    def updatedAt=(value)
      @updatedAt = value_to_time(value)
    end
  end
end
