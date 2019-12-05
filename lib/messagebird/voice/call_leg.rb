# frozen_string_literal: true

require 'messagebird/voice/base'

module MessageBird
  module Voice
    class CallLeg < MessageBird::Voice::Base
      attr_accessor :id, :call_id, :source, :destination, :status, :direction, :cost, :currency, :duration, :created_at, :updated_at, :answered_at, :ended_at
    end
  end
end
