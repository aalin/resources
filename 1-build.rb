require "bundler/setup"
require "async"

require_relative "resources/compiler"
require_relative "plugins/resolve_relative_plugin"
require_relative "plugins/import_url_plugin"
require_relative "plugins/realpath_plugin"
require_relative "plugins/ruby_plugin"

Async do
  compiler = Resources::Compiler.new(
    root: File.join(__dir__, "app"),
    entries: "/main.rb",
    plugins: [
      ResolveRelativePlugin,
      RealpathPlugin,
      ImportUrlPlugin,
      RubyPlugin,
    ]
  )

  output = compiler.compile

  filename = "bundle.marshal"
  puts "Writing bundle to #{filename}"
  File.write(filename, Marshal.dump(output))
end
