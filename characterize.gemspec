require_relative "lib/characterize/version"

Gem::Specification.new do |spec|
  spec.name = "characterize"
  spec.version = Characterize::VERSION
  spec.authors = ["Jim Gay"]
  spec.email = ["jim@saturnflyer.com"]
  spec.description = "Use plain modules like presenters"
  spec.summary = "Use plain modules like presenters"
  spec.homepage = "https://github.com/saturnflyer/characterize"
  spec.license = "MIT"

  spec.require_paths = ["lib"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/saturnflyer/characterize"
  spec.metadata["changelog_uri"] = "https://github.com/saturnflyer/characterize/blob/master/CHANGELOG.md"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  end
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_dependency "casting", "~> 1.0.2"
  spec.add_dependency "rails", ">= 6.1"
end
