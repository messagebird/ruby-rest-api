require 'messagebird/list'

module MessageBird
  class CallList < List

    def data=(value)
      @items = value.map { |i| @type.new i }
    end

  end
end
