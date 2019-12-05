# frozen_string_literal: true

require 'messagebird/voice/base'

module MessageBird
  module Voice
    class Webhook < MessageBird::Voice::Base
      attr_accessor :id, :url, :token, :created_at, :updated_at
    end
  end
end
