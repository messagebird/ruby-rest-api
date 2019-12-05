# frozen_string_literal: true

require 'messagebird/voice/base'

module MessageBird
  module Voice
    class CallLeg < MessageBird::Voice::Base
      attr_accessor :id, :callId, :source, :destination, :status, :direction, :cost, :currency, :duration, :createdAt, :updatedAt, :answeredAt, :endedAt
    end
  end
end
