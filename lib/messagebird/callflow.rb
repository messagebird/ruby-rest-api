require "messagebird/base"

module MessageBird
  class CallFlow < MessageBird::Base
    attr_accessor :id, :title, :record, :steps, :default, :createdAt, :updatedAt

    def initialize(json)
      params = json.include?("data") ? json["data"].first : json
      super(params)
    end

    def steps=(json)
      @steps = json.map { |c| MessageBird::CallFlowStep.new(c) }
    end

    def createdAt=(value)
      @createdAt = value_to_time(value)
    end

    def updatedAt=(value)
      @updatedAt = value_to_time(value)
    end
  end

  class CallFlowList < List
    attr_accessor :perPage, :currentPage, :pageCount, :totalCount
    PER_PAGE = 20
    CURRENT_PAGE = 1

    def data=(value)
      self.items = value
    end

    def pagination=(value)
      value.each do |k, v|
        begin
          send("#{k}=", v)
        rescue NoMethodError
        end
      end
    end
  end

  class CallFlowStep < MessageBird::Base
    attr_accessor :id, :action, :options

    def options=(json)
      @options = CallFlowStepOption.new(json)
    end
  end

  class CallFlowStepOption < MessageBird::Base
    attr_accessor :destination, :payload, :language, :voice, :repeat,
                  :media, :length, :maxLength, :timeout, :finishOnKey, :transcribe,
                  :transcribeLanguage, :record, :url, :ifMachine, :machineTimeout,
                  :onFinish, :mask
  end
end
