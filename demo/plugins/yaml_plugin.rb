require "yaml"
require "parser"
require "unparser"

class YAMLPlugin < Vandelay::Plugin
  EXTNAME = ".yaml"

  def load(id)
    return unless id.end_with?(EXTNAME)

    code = compiler.read(id)
    ruby = YAML.load(code, symbolize_names: true).inspect
    ast  = Parser::CurrentRuby.parse(ruby)

    { code:, ast: }
  end

  def transform(code, id)
    return unless id.end_with?(EXTNAME)

    unparsed = Unparser.unparse(get_resource_info(id).ast)

    <<~RUBY
      export default: #{unparsed}
    RUBY
  end
end
