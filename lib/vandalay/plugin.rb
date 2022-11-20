# typed: strict
# frozen_string_literal: true

module Vandalay
  class Plugin
    extend T::Sig

    LoadResult = T.type_alias do
      T.any(String, { code: String, ast: T.untyped })
    end

    sig {returns(Compiler)}
    attr_reader :compiler

    sig {params(compiler: Compiler).void}
    def initialize(compiler)
      @compiler = compiler
    end

    # importee: the first string passed to import().
    # importer: the resolved id of the module where import() is called.
    sig {params(importee: String, importer: String).returns(T.nilable(String))}
    def resolve_id(importee, importer)
    end

    sig {params(id: String).returns(T.nilable(LoadResult))}
    def load(id)
    end

    sig {params(code: LoadResult, id: String).returns(T.nilable(String))}
    def transform(code, id)
    end

    sig {params(resource_info: ResourceInfo).void}
    def resource_parsed(resource_info)
    end

    private

    sig {params(id: String).returns(ResourceInfo)}
    def get_resource_info(id)
      compiler.get_resource_info(id) or raise "Resource info not found: #{id}"
    end

    sig {params(importee: String, importer: String).returns(String)}
    def resolve(importee, importer)
      compiler.resolve_id(importee, importer)
    end

    sig {params(message: String).void}
    def error(message)
      puts "\e[31m#{self.class.name}: #{message}\e[0m"
      raise message
    end

    sig {params(message: String).void}
    def warn(message)
      puts "\e[33m#{self.class.name}: #{message}\e[0m"
    end
  end
end
