# frozen_string_literal: true

require 'messagebird/voice/base'

module MessageBird
  module Voice
    class Webhook < MessageBird::Voice::Base
      attr_accessor :id, :url, :token, :createdAt, :updatedAt
    end
  end
end
