# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class VoiceWebhook < MessageBird::Base
    attr_accessor :id, :url, :token, :createdAt, :updatedAt
  end
end
