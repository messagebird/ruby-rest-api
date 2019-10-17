require 'messagebird/list'

module MessageBird
  class CallList < List
    attr_accessor :perPage, :currentPage, :pageCount, :totalCount
    PER_PAGE = 20
    CURRENT_PAGE = 1
    def data=(value)
      @items = value.map { |i| @type.new i }
    end

    def pagination=(value)
      value.each do |k,v|
        begin
          send("#{k}=", v)
        rescue NoMethodError
          # Silently ignore parameters that are not supported.
        end
      end
    end
  end
end
