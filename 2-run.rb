require "bundler/setup"
require "async"

require_relative "resources/runtime"

Async do
  runtime = Resources::Runtime.new(
    Marshal.load(File.read("bundle.marshal"))
  )

  runtime.load("/main.rb")
end
