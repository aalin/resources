# typed: strict
# frozen_string_literal: true

require "brotli"

require_relative "base"

module Vandelay
  module Assets
    module Generators
      class WriteFile < Base
        extend T::Sig

        sig { params(contents: String, compress: T::Boolean).void }
        def initialize(contents:, compress:)
          @contents = contents
          @compress = compress
        end

        sig { override.params(path: String).void }
        def call(path)
          write_file(path, @contents)

          write_file(path + ".br", Brotli.deflate(@contents)) if @compress
        end

        private

        sig { params(path: String, content: String).void }
        def write_file(path, content)
          return if File.exist?(path)
          File.write(path, content)
        end
      end
    end
  end
end
