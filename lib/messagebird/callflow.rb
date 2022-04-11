# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class CallFlow < MessageBird::Base
    attr_accessor :id, :title, :record, :default
    attr_reader :steps, :created_at, :updated_at

    def initialize(json)
      params = json.include?('data') ? json['data'].first : json
      super(params)
    end

    def steps=(json)
      @steps = json.map { |c| MessageBird::CallFlowStep.new(c) }
    end

    def created_at=(value)
      @created_at = value_to_time(value)
    end

    def updated_at=(value)
      @updated_at = value_to_time(value)
    end
  end

  class CallFlowList < List
    attr_accessor :per_page, :current_page, :page_count, :total_count

    PER_PAGE = 20
    CURRENT_PAGE = 1

    def data=(value)
      self.items = value
    end

    def pagination=(value)
      value.each do |k, v|
        send("#{k}=", v)
      rescue NoMethodError
        puts 'An error occurred while listing callflows'
      end
    end
  end

  class CallFlowStep < MessageBird::Base
    attr_accessor :id, :action

    def options=(json)
      @options = CallFlowStepOption.new(json)
    end
  end

  class CallFlowStepOption < MessageBird::Base
    attr_accessor :destination, :payload, :language, :voice, :repeat,
                  :media, :length, :max_length, :timeout, :finish_on_key, :transcribe,
                  :transcribe_language, :record, :url, :if_machine, :machine_timeout,
                  :on_finish, :mask
  end
end
