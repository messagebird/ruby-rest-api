# frozen_string_literal: true

require 'messagebird/voice/base'
require 'messagebird/voice/webhook'

module MessageBird
  module Voice
    class Call < MessageBird::Base
      attr_accessor :id, :status, :source, :destination, :created_at, :updated_at, :ended_at, :call_flow
      attr_reader :webhook

      def initialize(json)
        params = json.include?('data') ? json['data'].first : json
        super(params)
      end

      def webhook=(webhook)
        @webhook = Voice::Webhook.new(webhook)
      end
    end
  end
end
