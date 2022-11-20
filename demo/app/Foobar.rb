RemoteClass = import("https://gist.githubusercontent.com/aalin/353f074f26a6d91223061b885523cab3/raw/612460a3f575719f027913effc4e61475ee00f2b/RemoteClass.rb eb2cbb8ef37f8517b4b1b164b4bfbf2fc9c95822680247bc7a48707c9d4ecb7c")

class Foobar
  def initialize(value)
    @value = value
  end

  def foobar
    RemoteClass.new.test
    "foobar #{@value}"
  end
end

export default: Foobar
