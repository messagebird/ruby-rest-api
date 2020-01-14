require 'messagebird/base'

module MessageBird 
  class Number < MessageBird::Base
    attr_accessor :number, :country, :region, :locality, :features, :tags, :type, :status
    attr_reader :created_at, :renewal_at
    
    def created_at=(value)
      @created_at = Time.parse(value)
    end

    def renewal_at=(value)
      @renewal_at = Time.parse(value)
    end
  end 
end 
