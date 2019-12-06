# frozen_string_literal: true

require 'messagebird/base'

module MessageBird
  module Voice
    class Transcription < MessageBird::Voice::Base
      attr_accessor :id, :recordingId, :error, :createdAt, :updatedAt, :_links, :uri

      def handle_links(links_object)
        @uri = links_object['file']
      end
    end
  end
end
