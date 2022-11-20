module Resources
  class Plugin
    attr_reader :compiler

    def initialize(compiler)
      @compiler = compiler
    end

    # source: the unresolved path passed to import().
    # importer: the resolved id of the module where import() is called.
    # returns nil or a resolved path.
    def resolve_id(source, importer)
    end

    # id: the resolved id (filename) of the module.
    # returns nil or loaded source code.
    def load(id)
    end

    # code: return value of load().
    # returns nil or transformed code that can be evaluated inside Module.
    def transform(code, id)
    end

    def resource_parsed(resource_info)
    end

    private

    def get_resource_info(id)
      compiler.get_resource_info(id) or raise "Resource info not found: #{id}"
    end

    def resolve_id(importee, importer)
      compiler.resolve_id(importee, importer)
    end

    def error(e)
      puts "\e[31m#{self.class.name}: #{warning}\e[0m"
      raise e
    end

    def warn(warning)
      puts "\e[33m#{self.class.name}: #{warning}\e[0m"
    end
  end
end
