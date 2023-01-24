Hello = import("./Hello")
Data = import("./Data.yaml")
Data2 = import("./test.json")
p Hello

hello = Hello.new("Luke Skywalker")

puts "\e[35m#{self.inspect}: START\e[0m"
puts hello.hello
p Data
p Data2
puts "\e[35m#{self.inspect}: END\e[0m"
