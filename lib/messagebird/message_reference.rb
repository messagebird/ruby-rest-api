# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class MessageReference < MessageBird::Base
    attr_accessor :href, :total_count
  end
end
