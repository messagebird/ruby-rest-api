# frozen_string_literal: true

require 'messagebird/list'

module MessageBird
  module Voice
    class List < List
      attr_accessor :per_page, :current_page, :page_count, :total_count
      PER_PAGE = 20
      CURRENT_PAGE = 1
      def data=(value)
        # Call List API retruns data object instead of items
        # to make it consistence with the rest of the SDK we shall
        # propagate it to items= method
        self.items = value.nil? ? [] : value
      end

      # map the pagination data to root level properties
      def pagination=(value)
        map_hash_elements_to_self(value)
      end
    end
  end
end
