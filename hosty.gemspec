$:.push File.expand_path("../lib", __FILE__)
require "hosty"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hosty"
  s.summary     = "Simple host configuration."
  s.description = %{
    HostConfig is a very simple AWS host config
    tool I use for my apps.
  }
  s.version     = Hosty::VERSION
  s.authors     = ["Ryan Funduk"]
  s.email       = ["ryan@funduk.ca"]
  s.homepage    = "https://github.com/rfunduk/hosty"
  s.license     = "MIT"

  s.files = Dir["{lib}/*", "LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency 'aws-sdk', '>= 2.0.41'
end
