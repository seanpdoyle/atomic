$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "atomic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "atomic"
  spec.version     = Atomic::VERSION
  spec.authors     = ["Sean Doyle"]
  spec.email       = ["sean.p.doyle24@gmail.com"]
  spec.homepage    = "https://github.com/seanpdoyle/atomic"
  spec.summary     = "Use `ActionView` partials for your application's components"
  spec.description = "Use the `atomic_tag` and `atomic` helper methods to access your design system."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.2"
end
