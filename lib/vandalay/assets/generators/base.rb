module Vandalay
  module Assets
    module Generators
      class Base
        def call(path)
          raise NotImplementedError,
            "#{self.class.name}##{__method__} is not implemented"
        end
      end
    end
  end
end
