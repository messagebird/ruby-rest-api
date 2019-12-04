# frozen_string_literal: true

module MessageBird
  class CallWebhook < MessageBird::Base
    attr_accessor :url, :token
  end
end
