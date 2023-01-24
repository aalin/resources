require "digest/sha2"
require "rszr"

class ImagePlugin < Vandelay::Plugin
  EXTENSIONS = %w[.png .jpg .jpeg .webp .gif]

  def load(id)
    filename, query = id.split("?", 2)
    extname = File.extname(filename)
    return unless EXTENSIONS.include?(extname)

    params = CGI.parse(query.to_s).transform_keys(&:to_sym)
    hash = Digest::SHA256.file(compiler.absolute_path(filename))

    { code: { params:, hash: } }
  end

  def transform(code, id)
    filename, query = id.split("?", 2)
    extname = File.extname(filename)
    return unless EXTENSIONS.include?(extname)

    code => params:

    image = Rszr::Image.load(compiler.absolute_path(filename))
    image.resize!(400, 300)

    <<~RUBY
      Export = "#{hello}"
    RUBY
  end
end
