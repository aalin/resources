# typed: true
# frozen_string_literal: true

module Vandelay
  module Assets
    class Asset
      extend T::Sig

      sig {returns(T::Set[String])}
      attr_reader :dependants
      sig {returns(String)}
      attr_reader :filename

      sig {params(filename: String, generator: Generators::Base).void}
      def initialize(filename, generator)
        @dependants = Set.new
        @filename = filename
        @generator = generator
      end

      def generate(path)
        @generator.call(File.join(path, filename))
      end
    end
  end
end
