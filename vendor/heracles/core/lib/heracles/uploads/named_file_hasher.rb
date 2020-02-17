module Heracles
  module Uploads
    class NamedFileHasher
      def hash(file_name)
        hash = SecureRandom.hex(30)
        hash_partition = hash.scan(/.{3}/).first(3).join("/")

        "#{hash_partition}/#{hash}/#{file_name}"
      end
    end
  end
end
