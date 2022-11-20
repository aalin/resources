# typed: strict
# frozen_string_literal: true

require_relative "resource_info"

module Vandalay
  class Runtime
    class ResourceModule < Module
      extend T::Sig

      sig {returns(String)}
      attr_reader :id
      sig {returns(T::Hash[Symbol, T.untyped])}
      attr_reader :exports

      sig {params(runtime: Runtime, id: String, code: String).void}
      def initialize(runtime, id, code)
        @id = id
        @runtime = runtime
        @exports = T.let({}, T::Hash[Symbol, T.untyped])
        instance_eval(code)
      end

      sig {params(args: T.any(Class, Module), kwargs: T.untyped).void}
      def export(*args, **kwargs)
        args.each do |arg|
          exports[arg.name.to_s.split("::").last.to_s.to_sym] = arg
        end

        kwargs.each do |key, arg|
          exports[key] = arg
        end
      end

      sig {params(names: Symbol).returns(T.any(T.untyped, T::Array[T.untyped]))}
      def get_exports(*names)
        case names
        in []
          exports.fetch(:default) do
            raise "Could not find a default export in #{@id}"
          end
        in [name]
          exports.fetch(name)
        else
          T.unsafe(exports).values_at(*names)
        end
      end

      sig {params(id: String, names: Symbol).returns(T.any(T.untyped, T::Array[T.untyped]))}
      def import(id, *names)
        T.unsafe(@runtime.load(id)).get_exports(*names)
      end
    end

    extend T::Sig

    sig {params(resource_infos: T::Hash[String, ResourceInfo]).void}
    def initialize(resource_infos)
      @resource_infos = resource_infos
      @resources = T.let({}, T::Hash[String, ResourceModule])
    end

    sig {params(resource_info: ResourceInfo).void}
    def swap(resource_info)
      @resource_infos[resource_info.id] = resource_info
      @resources.delete(resource_info.id)
      load(resource_info.id)
    end

    sig {params(id: String).returns(ResourceModule)}
    def load(id)
      @resources[id] ||= begin
        code = @resource_infos.fetch(id).code.to_s
        ResourceModule.new(self, id, code)
      end
    end
  end
end
