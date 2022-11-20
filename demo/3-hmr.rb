require "bundler/setup"
require "async"
require "vandalay"

require_relative "plugins/resolve_relative_plugin"
require_relative "plugins/import_url_plugin"
require_relative "plugins/realpath_plugin"
require_relative "plugins/ruby_plugin"
require_relative "plugins/yaml_plugin"
require_relative "plugins/json_plugin"

class HMRPlugin < Vandalay::Plugin
  class Factory
    def initialize(**options)
      @options = options
    end

    def new(compiler)
      HMRPlugin.new(compiler, **@options)
    end
  end

  def self.configure(**options)
    Factory.new(**options)
  end

  def initialize(compiler, runtime:)
    super(compiler)
    @runtime = runtime
  end

  def resource_parsed(resource_info)
    @runtime.swap(resource_info)
  end
end

Async do
  on_swap = Async::Notification.new

  runtime = Vandalay::Runtime.new({})

  compiler = Vandalay::Compiler.new(
    root: File.join(__dir__, "app"),
    entries: "/main.rb",
    plugins: [
      ResolveRelativePlugin,
      RealpathPlugin,
      ImportUrlPlugin,
      RubyPlugin,
      YAMLPlugin,
      JSONPlugin,
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
