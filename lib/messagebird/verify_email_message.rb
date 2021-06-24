# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  class VerifyEmailMessage < MessageBird::Base
    attr_accessor :id, :status
  end
end
