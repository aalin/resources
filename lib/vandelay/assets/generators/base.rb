# typed: strict
# frozen_string_literal: true

module Vandelay
  module Assets
    module Generators
      class Base
        extend T::Sig
        extend T::Helpers
        abstract!

        sig { overridable.params(path: String).void }
        def call(path)
          raise NotImplementedError,
                "#{self.class.name}##{__method__} is not implemented"
        end
      end
    end
  end
end
