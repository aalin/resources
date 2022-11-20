# typed: true
# frozen_string_literal: true

require "digest/sha2"
require "base58-alphabets"

require_relative "runtime"
require_relative "resource_info"
require_relative "plugin"
require_relative "graph"
require_relative "assets"

module Vandalay
  class Compiler
    class ModuleNotFoundError < StandardError
    end

    attr_reader :graph

    def initialize(root:, entries:, plugins: [])
      @root = root
      @entries = Array(entries)
      @plugins = plugins.map { _1.new(self) }

      @graph = Graph.new
      @assets = {}
    end

    def get_resource_info(id)
      @graph.get_node(id)
    end

    def compile
      @entries.each { load(_1) }
      @graph.nodes
    end

    def read(id, encoding: 'utf-8')
      File.read(absolute_path(id), encoding:)
    rescue Errno::ENOENT
      raise ModuleNotFoundError, "Could not find module #{id}"
    end

    def content_hash(id)
      Digest::SHA256.file(absolute_path(id)).digest
    end

    def absolute_path_to_id(absolute_path)
      absolute_path.delete_prefix(@root)
    end

    def absolute_path(id)
      File.join(@root, File.expand_path(id, "/"))
    end

    def emit_asset(id, asset)
      @assets[asset.filename] ||= asset
      asset.dependants.add(id)
      asset
    end

    def reload(id)
      @graph
        .dependencies_of(id)
        .reverse_each do |deps|
          deps.each do |dep|
            puts "\e[33mUnloading #{dep}\e[0m"
            unload(dep)

            if @entries.include?(dep)
              load(dep)
            end
          end
      end
    end

    def load(source, importer = nil)
      id = resolve_id(source, importer)

      if id == importer
        # TODO: Maybe check the dep graph instead
        raise "#{id} is importing itself"
      end

      info = @graph.add_node(id)

      unless info.code
        puts "\e[32mLoading #{id}\e[0m"

        case load_code(id)
        in code:, ast:
          info.ast = ast
          info.code = transform(code, id)
        in String => code
          info.code = transform(code, id)
        end
      end

      resource_parsed(info)

      if importer
        @graph.add_node(importer)
        @graph.add_dependency(importer, id)
      end

      info
    end

    def unload(id)
      @graph.delete_node(id)
      @assets.values.each { _1.dependants.delete(id) }
    end

    def resolve_id(source, importer = nil)
      @plugins.each do |plugin|
        if resolved = plugin.resolve_id(source, importer)
          return resolved
        end
      end

      raise "Could not resolve #{source.inspect} from #{importer.inspect}"
    end

    private

    def load_code(id)
      @plugins.each do |plugin|
        if code = plugin.load(id)
          return code
        end
      end

      raise "Could not load #{id.inspect}"
    end

    def transform(code, id)
      @plugins.each do |plugin|
        if transformed = plugin.transform(code, id)
          return transformed
        end
      end

      raise "Could not transform #{id.inspect}"
    end

    def resource_parsed(resource_info)
      @plugins.each do |plugin|
        plugin.resource_parsed(resource_info)
      end

      resource_info
    end
  end
end
