# frozen_string_literal: true

require "messagebird/base"

module MessageBird
  class CallFlowStep < MessageBird::Base
    attr_accessor :id, :action, :options
  end
end
