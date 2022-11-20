require "brotli"

require_relative "base"

module Resources
  module Assets
    module Generators
      class WriteFile
        def initialize(contents:, compress:)
          @contents = contents
          @compress = compress
        end

        def call(path)
          write_file(path, @contents)

          if @compress
            write_file(path + ".br", Brotli.deflate(@contents))
          end
        end

        private

        def write_file(path, content)
          return if File.exist?(path)
          File.write(path, content)
        end
      end
    end
  end
end
