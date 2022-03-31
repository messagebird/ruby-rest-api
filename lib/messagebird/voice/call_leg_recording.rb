# frozen_string_literal: true

require 'messagebird/voice/base'

module MessageBird
  module Voice
    class CallLegRecording < MessageBird::Voice::Base
      # default attributes from the API
      attr_accessor :id, :format, :type, :leg_id, :status, :duration
      attr_accessor :created_at, :updated_at

      # further processed attributes for convenience
      attr_accessor :_links, :uri

      # Grab the URI to the downloadable file and provide it as a direct attribute
      def handle_links(links_object)
        @uri = links_object['file']
      end
    end
  end
end
