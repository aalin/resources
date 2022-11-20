require "bundler/setup"
require "async"

require_relative "resources/compiler"
require_relative "plugins/resolve_relative_plugin"
require_relative "plugins/import_url_plugin"
require_relative "plugins/realpath_plugin"
require_relative "plugins/ruby_plugin"
require_relative "plugins/yaml_plugin"

class HMRPlugin < Resources::Plugin
  class Factory
    def initialize(options)
      @options = options
    end

    def new(compiler)
      HMRPlugin.new(compiler, @options)
    end
  end

  def self.configure(options)
    Factory.new(options)
  end

  def initialize(compiler, options)
    super(compiler)
    @options = options
  end

  def resource_parsed(resource_info)
    @options[:runtime].swap(resource_info)
  end
end

Async do
  runtime = Resources::Runtime.new({})

  compiler = Resources::Compiler.new(
    root: File.join(__dir__, "app"),
    entries: "/main.rb",
    plugins: [
      ResolveRelativePlugin,
      RealpathPlugin,
      ImportUrlPlugin,
      RubyPlugin,
      YAMLPlugin,
      HMRPlugin.configure(runtime:)
    ]
  )

  puts "#### COMPILING"

  compiler.compile

  puts "#### SLEEPING"

  sleep 1
  puts "#### RELOADING"
  compiler.reload("/Hello.rb")
  puts "#### EXITING"
end
