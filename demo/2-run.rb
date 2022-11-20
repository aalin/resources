require "bundler/setup"
require "async"
require "vandelay"

Async do
  runtime = Vandelay::Runtime.new(
    Marshal.load(File.read("bundle.marshal"))
  )

  runtime.load("/main.rb")
end
