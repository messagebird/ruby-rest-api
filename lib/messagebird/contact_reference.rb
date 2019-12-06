# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class ContactReference < MessageBird::Base
    attr_accessor :href, :total_count
  end
end
