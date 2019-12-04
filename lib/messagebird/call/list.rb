# frozen_string_literal: true

require 'messagebird/list'

module MessageBird
  class CallList < List
    PER_PAGE = 20
    CURRENT_PAGE = 1

    attr_accessor :per_page, :current_page, :page_count, :total_count

    def data=(value)
      # Call List API retruns data object instead of items
      # to make it consistence with the rest of the SDK we shall
      # propagate it to items= method
      self.items = value
    end

    def pagination=(value)
      value.each do |k, v|
        m = k.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
        send("#{m}=", v) if respond_to?(:"#{m}=")
      end
    end
  end
end
