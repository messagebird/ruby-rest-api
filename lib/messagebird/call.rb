require 'messagebird/base'

module MessageBird
  class Call < MessageBird::Base
    attr_accessor :id, :status, :source, :destination, :createdAt, :updatedAt, :endedAt
    def initialize(json)
      params = json.include?("data") ? json["data"].first : json
      super(params)
    end
  end
end
