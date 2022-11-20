class ResolveRelativePlugin < Vandelay::Plugin
  def resolve_id(source, importer)
    if source.start_with?("./") || source.start_with?("../")
      compiler.resolve_id(
        File.expand_path(source, File.dirname(importer)),
        importer
      )
    end
  end
end
