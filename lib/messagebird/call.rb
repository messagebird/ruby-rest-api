require 'messagebird/base'
require 'messagebird/call/webhook'

module MessageBird
  class Call < MessageBird::Base
    attr_accessor :id, :status, :source, :destination, :createdAt, :updatedAt, :endedAt, :webhook, :callFlow
    def initialize(json)
      params = json.include?("data") ? json["data"].first : json
      super(params)
    end

    def webhook=(webhook)
      @webhook = CallWebhook.new(webhook)
    end
  end
end
