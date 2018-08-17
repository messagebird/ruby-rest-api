require 'messagebird/base'

class MessageReference < MessageBird::Base
  attr_accessor :href, :totalCount
end