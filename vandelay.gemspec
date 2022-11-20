# frozen_string_literal: true

require_relative "lib/vandelay/version"

Gem::Specification.new do |spec|
  spec.name = "vandelay"
  spec.version = Vandelay::VERSION
  spec.authors = ["Andreas Alin"]
  spec.email = ["andreas.alin@gmail.com"]

  spec.summary = "Modules with import/export for Ruby"
  spec.homepage = "https://github.com/aalin/vandelay"

  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.2"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aalin/vandelay"
  spec.metadata["changelog_uri"] = "https://github.com/aalin/vandelay/commits"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "async"
  spec.add_dependency "async-http"
  spec.add_dependency "base58-alphabets"
  spec.add_dependency "brotli"
  spec.add_dependency "parser"
  spec.add_dependency "pry"
  spec.add_dependency "sorbet-runtime"
  spec.add_dependency "unparser"
end
