# frozen_string_literal: true

require 'messagebird/list'

module MessageBird
  module Voice
    class List < List
      attr_accessor :perPage, :currentPage, :pageCount, :totalCount
      PER_PAGE = 20
      CURRENT_PAGE = 1
      def data=(value)
        # Call List API retruns data object instead of items
        # to make it consistence with the rest of the SDK we shall
        # propagate it to items= method
        self.items = value.nil? ? [] : value
      end

      def pagination=(value)
        value.each do |k, v|
          method_name = "#{k}="
          send(method_name, v) if respond_to? method_name
        end
      end
    end
  end
end
