module MessageBird
  module Voice
    class CallLeg < MessageBird::Base
      attr_accessor :id, :callId, :source, :destination, :status, :direction, :cost, :currency, :duration, :createdAt, :updatedAt, :answeredAt, :endedAt
    end
  end
end
  