require_relative "resource_info"

module Vandalay
  class Runtime
    class ResourceModule < Module
      attr_reader :id
      attr_reader :exports

      def initialize(runtime, id, code)
        @id = id
        @runtime = runtime
        @exports = {}
        instance_eval(code)
      end

      def export(*args, **kwargs)
        args.each do |arg|
          exports[arg.name.split("::").last.to_sym] = arg
        end

        kwargs.each do |key, arg|
          exports[key] = arg
        end
      end

      def get_exports(*names)
        case names
        in []
          exports.fetch(:default) do
            raise "Could not find a default export in #{@id}"
          end
        in [name]
          exports.fetch(name)
        else
          exports.values_at(*names)
        end
      end

      def import(id, *names)
        @runtime.load(id).get_exports(*names)
      end
    end

    def initialize(resource_infos)
      @resource_infos = resource_infos
      @vandalay = {}
    end

    def marshal_dump =  @resource_infos
    def marshal_load(resource_infos)
      @resource_infos = resource_infos
      @vandalay = {}
    end

    def swap(resource_info)
      id = resource_info.id
      @resource_infos[id] = resource_info
      @vandalay.delete(id)
      load(id)
    end

    def load(id)
      @vandalay[id] ||= begin
        code = @resource_infos.fetch(id).code
        ResourceModule.new(self, id, code)
      end
    end
  end
end
