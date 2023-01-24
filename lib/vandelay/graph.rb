# typed: strict
# frozen_string_literal: true

require "set"
require "tsort"

module Vandelay
  class Graph
    extend T::Sig

    sig { void }
    def initialize
      @nodes = T.let({}, T::Hash[String, ResourceInfo])
    end

    sig { returns(T::Hash[String, ResourceInfo]) }
    attr_reader :nodes

    sig { params(resource_info: ResourceInfo).void }
    def swap(resource_info)
      @nodes[resource_info.id] = resource_info
    end

    sig { params(id: String, type: Symbol).returns(ResourceInfo) }
    def fetch_node(id, type = :node)
      @nodes.fetch(id) do
        raise ArgumentError,
              "Could not find #{type} #{id} #{id.inspect} in #{@nodes.keys.inspect}"
      end
    end

    sig { params(id: String).returns(T.nilable(ResourceInfo)) }
    def get_node(id)
      @nodes[id]
    end

    sig { params(id: String).returns(ResourceInfo) }
    def add_node(id)
      @nodes[id] ||= ResourceInfo.new(id:)
    end

    sig { params(id: String).void }
    def delete_node(id)
      delete_connections(id) if @nodes.delete(id)
    end

    sig { params(source_id: String, target_id: String).void }
    def add_dependency(source_id, target_id)
      with_source_and_target(source_id, target_id) do |source, target|
        source.outgoing.add(target_id)
        target.incoming.add(source_id)
      end
    end

    sig { params(source_id: String, target_id: String).void }
    def delete_dependency(source_id, target_id)
      with_source_and_target(source_id, target_id) do |source, target|
        source.outgoing.delete(target_id)
        target.incoming.delete(source_id)
      end
    end

    sig { params(id: String).returns(T::Enumerator[T::Array[String]]) }
    def dependencies_of(id)
      TSort.each_strongly_connected_component_from(
        id,
        ->(n, &b) { fetch_node(n, :source).incoming.each(&b) }
      )
    end

    sig { params(id: String).returns(T::Enumerator[T::Array[String]]) }
    def dependants_of(id)
      TSort.each_strongly_connected_component_from(
        id,
        ->(n, &b) { fetch_node(n, :target).outgoing.each(&b) }
      )
    end

    private

    sig { params(id: String).void }
    def delete_connections(id)
      @nodes.each { |node| node.delete(id) }
    end

    sig do
      params(
        source_id: String,
        target_id: String,
        block: T.proc.params(arg0: ResourceInfo, arg1: ResourceInfo).void
      ).void
    end
    def with_source_and_target(source_id, target_id, &block)
      yield(fetch_node(source_id, :source), fetch_node(target_id, :target))
    end
  end
end
