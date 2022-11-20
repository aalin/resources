Foobar = import("./foobar")

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
