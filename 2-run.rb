require "bundler/setup"
require "async"
require "vandalay"

Async do
  runtime = Vandalay::Runtime.new(
    Marshal.load(File.read("bundle.marshal"))
  )

  runtime.load("/main.rb")
end
