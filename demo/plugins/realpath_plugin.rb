class RealpathPlugin < Vandalay::Plugin
  def resolve_id(source, importer)
    absolute_path = compiler.absolute_path(source)

    return unless File.exist?(absolute_path)

    realpath = File.realpath(absolute_path)

    id = compiler.absolute_path_to_id(realpath)

    unless realpath == absolute_path
      warn(<<~EOF)
        #{source.inspect} has incorrect casing, should be #{id.inspect}
        From: #{importer}
      EOF
    end

    id
  end
end
