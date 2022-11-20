# typed: strict
# frozen_string_literal: true

module Vandalay
  class ResourceInfo < T::Struct
    extend T::Sig

    MarshalFormat = T.type_alias do
      [String, String, T::Set[String], T::Set[String]]
    end

    const :id, String
    const :incoming, T::Set[String], default: Set.new
    const :outgoing, T::Set[String], default: Set.new

    prop :code, T.nilable(String)
    prop :ast, T.untyped, default: nil

    sig {returns(MarshalFormat)}
    def marshal_dump
      [@id, @code.to_s, @incoming, @outgoing]
    end

    sig {params(a: MarshalFormat).void}
    def marshal_load(a)
      @id, @code, @incoming, @outgoing = a
    end
  end
end
