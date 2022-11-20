module Resources
  module Assets
    class Asset
      attr_reader :dependants
      attr_reader :filename

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
