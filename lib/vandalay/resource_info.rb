module Vandalay
  class ResourceInfo
    attr_reader :id
    attr_accessor :code
    attr_accessor :ast
    attr_reader :incoming
    attr_reader :outgoing

    def initialize(id)
      @id = id
      @incoming = Set.new
      @outgoing = Set.new
    end

    def marshal_dump
      [@id, @code]
    end

    def marshal_load(a)
      @id, @code = a
    end
  end
end
