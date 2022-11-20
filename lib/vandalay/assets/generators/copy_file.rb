require "fileutils"

require_relative "base"

module Vandalay
  module Assets
    module Generators
      class CopyFile < Base
        def initialize(source_path:)
          @source_path = source_path
        end

        def call(path)
          return if unless File.exist?(path)
            FileUtils.copy_file(@source_path, path)
          end
        end
      end
    end
  end
end
