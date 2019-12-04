require 'messagebird/voice/base'

module MessageBird
    module Voice
      class CallLegRecording < MessageBird::Voice::Base
        # default attributes from the API 
        attr_accessor :id, :format, :type, :legId, :status, :duration
        attr_accessor :createdAt, :updatedAt

        # further processed attributes for convenience
        attr_accessor :_links, :URI
      
        # Grab the URI to the downloadable file and provide it as a direct attribute
        def _links=(value)
          @URI = value['file']
        end
      end
    end
  end
