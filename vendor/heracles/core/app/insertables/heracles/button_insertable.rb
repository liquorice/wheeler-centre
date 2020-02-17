module Heracles
  class ButtonInsertable < Insertable
    def button
      @button ||= @data
    end
  end
end
