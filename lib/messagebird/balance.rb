# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class Balance < MessageBird::Base
    attr_accessor :payment, :type, :amount
  end
end
