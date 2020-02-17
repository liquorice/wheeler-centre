module Ancestry
  # Adjust the ancestry column regexp pattern to allow UUIDs
  remove_const :ANCESTRY_PATTERN
  ANCESTRY_PATTERN = /\A[\w\-]+(\/[\w\-]+)*\z/

  module InstanceMethods
    private

    # Ancestry runs `#to_i` on the parent/ancestry primary keys unless
    # `#primary_key_type` here returns `:string`. Our primary key type is
    # `:uuid`, which should still be treated as a string anyway.
    def primary_key_type
      :string
    end
  end
end
