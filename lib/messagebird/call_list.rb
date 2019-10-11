require 'messagebird/list'

class CallList < List

  def data=(value)
    @items = value.map { |i| @type.new i }
  end

end
