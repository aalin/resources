require "digest/sha2"
require "async/http/internet"

class ImportUrlPlugin < Resources::Plugin
  class Internet < BasicObject
    def initialize
      @internet = ::Async::HTTP::Internet.new
    end

    def method_missing(*args, **kwargs, &block)
      @internet.send(*args, **kwargs, &block)
    end

    def marshal_dump
      nil
    end

    def marshal_load(*)
      @internet = ::Async::HTTP::Internet.new
    end
  end

  def initialize(*)
    super
    @internet = Internet.new
    @hashes = {}
  end

  def resolve_id(source, importer)
    return unless source.start_with?("https://")
    id, hash = source.split(" ", 2)
    @hashes[id] = hash
    id
  end

  def load(id)
    return unless id.start_with?("https://")

    body = @internet.get(id).read
    hash = Digest::SHA256.hexdigest(body)

    unless @hashes[id] == hash
      error("#{hash.inspect} does not match #{hashes[id].inspect}")
    end

    body
  end
end
