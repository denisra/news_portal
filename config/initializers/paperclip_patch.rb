module Paperclip
  class TempfileFactory

    def basename
      Digest::MD5.hexdigest(File.basename(@name, extension))
    end
  end
end