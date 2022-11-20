Hello = import("./Hello")
Data = import("./Data.yaml")

hello = Hello.new("Luke Skywalker")

puts "\e[35m#{self.inspect}: START\e[0m"
puts hello.hello
puts "\e[35m#{self.inspect}: END\e[0m"
