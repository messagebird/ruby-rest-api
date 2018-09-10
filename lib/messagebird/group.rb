require 'messagebird/base'
require 'messagebird/contact_reference'

module MessageBird
  class Group < MessageBird::Base
    attr_accessor :id, :href, :name, :contacts, :createdDatetime,
                  :updatedDatetime

    def contacts=(value)
      @contacts = MessageBird::ContactReference.new(value)
    end

    def createdDatetime=(value)
      @createdDatetime = value_to_time(value)
    end

    def updatedDatetime=(value)
      @updatedDatetime = value_to_time(value)
    end
  end
end