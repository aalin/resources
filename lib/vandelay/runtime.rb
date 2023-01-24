# typed: strict
# frozen_string_literal: true

require_relative "resource_info"

module Vandelay
  class Runtime
    class UndefinedExport < BasicObject
      class Error < ::StandardError
      end

      extend ::T::Sig

      sig {params(id: String).void}
      def initialize(id)
        @id = ::T.let(id, String)
      end

      sig {params(args: T.untyped).void}
      def method_missing(*args)
        ::Kernel.raise(Error, "#{@id} does not have an export")
      end
    end

    class ResourceModule < Module
      extend T::Sig

      sig { returns(String) }
      attr_reader :id

      sig { params(runtime: Runtime, id: String, code: String).void }
      def initialize(runtime, id, code)
        @id = id
        @runtime = runtime
        module_eval(code, id, 1)
      end

      sig do
        params(id: String).returns(T.untyped)
      end
      def import(id)
        mod = T.unsafe(@runtime.load(id))
        if mod.const_defined?(:Export)
          mod.const_get(:Export)
        else
          $stderr.puts "\e[33m#{}\e[0m"
          nil
        end
      end
    end

    extend T::Sig

    sig { params(resource_infos: T::Hash[String, ResourceInfo]).void }
    def initialize(resource_infos)
      @resource_infos = resource_infos
      @resources = T.let({}, T::Hash[String, ResourceModule])
    end

    sig { params(resource_info: ResourceInfo).void }
    def swap(resource_info)
      @resource_infos[resource_info.id] = resource_info
      @resources.delete(resource_info.id)
      load(resource_info.id)
    end

    sig { params(id: String).returns(ResourceModule) }
    def load(id)
      @resources[id] ||= begin
        code = @resource_infos.fetch(id).code.to_s
        ResourceModule.new(self, id, code)
      end
    end
  end
end
