require "json"
require "parser"
require "unparser"

class JSONPlugin < Vandalay::Plugin
  EXTNAME = ".json"

  def load(id)
    return unless id.end_with?(EXTNAME)

    code = compiler.read(id)
    ruby = JSON.parse(code, symbolize_names: true).inspect
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
