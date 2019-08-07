require 'messagebird/base'

module MessageBird 
  class Number < MessageBird::Base
    attr_accessor :number, :country, :region, :locality, :features, :tags, :type, :status
    attr_reader :createdAt, :renewalAt
    
    def createdAt=(value)
      @createdAt = value_to_time(value)
    end

    def renewalAt=(value)
      @renewalAt = value_to_time(value)
    end
  end 
end 
