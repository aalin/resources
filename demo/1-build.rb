require "bundler/setup"
require "async"
require "vandalay"

require_relative "plugins/resolve_relative_plugin"
require_relative "plugins/import_url_plugin"
require_relative "plugins/realpath_plugin"
require_relative "plugins/ruby_plugin"
require_relative "plugins/yaml_plugin"
require_relative "plugins/json_plugin"

Async do
  compiler = Vandalay::Compiler.new(
    root: File.join(__dir__, "app"),
    entries: "/main.rb",
    plugins: [
      ResolveRelativePlugin,
      RealpathPlugin,
      ImportUrlPlugin,
      RubyPlugin,
      JSONPlugin,
      YAMLPlugin,
    ]
  )

  output = compiler.compile

  filename = "bundle.marshal"
  puts "Writing bundle to #{filename}"
  File.write(filename, Marshal.dump(output))
end
