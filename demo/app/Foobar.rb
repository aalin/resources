RemoteClass = import("https://gist.githubusercontent.com/aalin/353f074f26a6d91223061b885523cab3/raw/1bac68a8381658e663852dc912329fb901ff3acb/RemoteClass.rb 4fc7e35ebbdaf21a5ba3b304fecdc0492356f510ed655fb364674d866d035b8c")

class Foobar
  def initialize(value)
    @value = value
  end

  def foobar
    RemoteClass.new.test
    "foobar #{@value}"
  end
end

Export = Foobar
