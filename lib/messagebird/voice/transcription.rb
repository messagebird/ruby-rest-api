# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  module Voice
    class Transcription < MessageBird::Voice::Base
      attr_accessor :id, :recording_id, :error, :created_at, :updated_at, :_links, :uri

      def handle_links(links_object)
        @uri = links_object['file']
      end
    end
  end
end
