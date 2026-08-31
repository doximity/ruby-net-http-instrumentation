# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "net/http/instrumentation/version"

Gem::Specification.new do |spec|
  spec.name = "nethttp-opentracing"
  spec.version = Net::Http::Instrumentation::VERSION
  spec.authors = ["Ben Fischer"]
  spec.email = ["bfischer@doximity.com"]

  spec.summary = "Doximity OpenTracing Instrumentation for Net::HTTP requests."
  spec.homepage = "https://github.com/doximity/ruby-net-http-instrumentation"
  spec.license = "Apache-2.0"

  # This gem is published to Doximity's internal Nexus gem repository, not to public
  # RubyGems.org. `allowed_push_host` makes `rake release` target Nexus and refuses
  # accidental pushes to RubyGems.org.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://artifacts.dox.support/repository/gems"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/doximity/ruby-net-http-instrumentation"
    spec.metadata["changelog_uri"] = "https://github.com/doximity/ruby-net-http-instrumentation/blob/master/CHANGELOG.md"
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # `vendor/` (a local bundler install path) is excluded so vendored gems never ship
  # inside the packaged .gem.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|vendor)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "opentracing", "~> 0.3"

  spec.add_development_dependency "opentracing_test_tracer", "~> 0.1"
  # sdoc 2.x templates reference RDoc::GhostMethod, which rdoc 8 removed;
  # keep rdoc below 8 until sdoc supports it.
  spec.add_development_dependency "rdoc", "~> 7.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "sdoc"
  spec.add_development_dependency "standardrb"
  spec.add_development_dependency "webmock", "~> 3.19"
end
