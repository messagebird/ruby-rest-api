require 'messagebird/voice/base'
require 'messagebird/call/webhook'

module MessageBird
  module Voice
    class Call < MessageBird::Voice::Base
      attr_accessor :id, :status, :source, :destination, :createdAt, :updatedAt, :endedAt, :webhook, :callFlow

      def webhook=(webhook)
        @webhook = CallWebhook.new(webhook)
      end
    end
  end
end
