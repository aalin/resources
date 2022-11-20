require "set"
require "tsort"

module Resources
  class Graph
    class Node
      attr :value
      attr :incoming
      attr :outgoing

      def initialize(value)
        @value = value
        @incoming = Set.new
        @outgoing = Set.new
      end

      def delete(id)
        @incoming.delete(id)
        @outgoing.delete(id)
      end
    end

    def initialize
      @nodes = {}
    end

    def add_node(id, value)
      @nodes[id] ||= Node.new(value)
    end

    def delete_node(id)
      if @nodes.delete(id)
        delete_connections(id)
      end
    end

    def add_dependency(source_id, target_id)
      with_source_and_target(source_id, target_id) do |source, target|
        source.outgoing.add(target_id)
        target.incoming.add(source_id)
      end
    end

    def delete_dependency(source_id, target_id)
      with_source_and_target(source_id, target_id) do |source, target|
        source.outgoing.delete(target_id)
        target.incoming.delete(source_id)
      end
    end

    def dependencies_of(id)
      TSort.each_strongly_connected_component_from(id, ->(n, &b) {
        fetch_node(:source, n).incoming.each(&b)
      })
    end

    def dependants_of(id)
      TSort.each_strongly_connected_component_from(id, ->(n, &b) {
        fetch_node(:target, n).outgoing.each(&b)
      })
    end

    private

    def delete_connections(id)
      @nodes.each { |node| node.delete(id) }
    end

    def with_source_and_target(source_id, target_id, &block)
      yield(
        fetch_node(:source, source_id),
        fetch_node(:target, target_id)
      )
    end

    def fetch_node(type, id)
      @nodes.fetch(id) do
        raise ArgumentError,
          "Could not find #{type} #{id} #{id.inspect} in #{@nodes.keys.inspect}"
      end
    end
  end
end
