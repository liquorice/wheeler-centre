module Heracles
  class VideoInsertable < Insertable
    def video
      @video ||= @data
    end
  end
end
