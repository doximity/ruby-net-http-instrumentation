# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "net/http/instrumentation/version"

Gem::Specification.new do |spec|
  spec.name          = "nethttp-opentracing"
  spec.version       = Net::Http::Instrumentation::VERSION
  spec.authors       = ["Ben Fischer"]
  spec.email         = ["bfischer@doximity.com"]

  spec.summary       = "Doximity OpenTracing Instrumentation for Net::HTTP requests."
  spec.homepage      = "https://github.com/doximity/ruby-net-http-instrumentation"
  spec.license       = "Apache-2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/doximity/ruby-net-http-instrumentation"
    spec.metadata["changelog_uri"] = "https://github.com/doximity/ruby-net-http-instrumentation/blob/master/CHANGELOG"
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # Exclude `vendor/` (the checked-in bundle install path and bundler cache from CI):
  # it is dev/test-only and would otherwise ship vendored 2020-era gems
  # (rack/rspec/rubocop/webmock) inside the packaged .gem.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|vendor)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "opentracing", "~> 0.3"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "dox-style"
  spec.add_development_dependency "opentracing_test_tracer", "~> 0.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "sdoc"
  spec.add_development_dependency "webmock", "~> 3.4.2"
end
