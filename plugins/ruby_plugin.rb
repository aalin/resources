require "pry"
require 'parser/current'

class RubyPlugin < Resources::Plugin
  EXTNAME = ".rb"

  class TransformImport < Parser::TreeRewriter
    def initialize(compiler, resource_info)
      @compiler = compiler
      @resource_info = resource_info
    end

    def on_send(node)
      if node in [:send, nil, :import, filename, *args]
        filename => :str, str
        dep = @compiler.load(str, @resource_info.id)
        replace(filename.loc.expression, dep.id.inspect)
      end
    end
  end

  def resolve_id(source, importer)
    if source.end_with?(EXTNAME)
      id =
        if importer
          File.join(File.dirname(importer), source)
        else
          source
        end
      compiler.resolve_id(id, importer)
    elsif importer&.end_with?(EXTNAME)
      compiler.resolve_id(source + EXTNAME, importer)
    end
  end

  def load(id)
    return unless id.end_with?(EXTNAME)
    code = compiler.read(id)
    ast = Parser::CurrentRuby.parse(code)
    { code:, ast: }
  end

  def transform(code, id)
    return unless id.end_with?(EXTNAME)

    resource_info = get_resource_info(id) or raise "No resource info found for #{id}"
    buffer = Parser::Source::Buffer.new(id, source: code)
    rewriter = TransformImport.new(compiler, resource_info)
    rewriter.rewrite(buffer, resource_info.ast)
  end
end
