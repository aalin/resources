# typed: strict
# frozen_string_literal: true

require "fileutils"

require_relative "base"

module Vandalay
  module Assets
    module Generators
      class CopyFile < Base
        sig {params(source_path: String).void}
        def initialize(source_path:)
          @source_path = source_path
        end

        sig {override.params(path: String).void}
        def call(path)
          return if unless File.exist?(path)
            FileUtils.copy_file(@source_path, path)
          end
        end
      end
    end
  end
end
