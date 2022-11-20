Foobar = import("./foobar")
Foo, Bar, BAZ = import("./multi", :Foo, :Bar, :BAZ)

class Hello
  def initialize(name)
    @name = name
    @foobar = Foobar.new(name.upcase)
  end

  def hello
    "hello #{@foobar.foobar}"
  end
end

export default: Hello
