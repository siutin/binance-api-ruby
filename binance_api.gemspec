
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "binance_api/version"

Gem::Specification.new do |spec|
  spec.name          = "binance_api"
  spec.version       = BinanceAPI::VERSION
  spec.authors       = ["osiutino"]
  spec.email         = ["osiutino@gmail.com"]

  spec.summary       = %q{unoffical Binance rubygem}
  spec.description   = %q{A Binance API wrapper written in ruby}
  spec.homepage      = "https://github.com/siutin/binance-api-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'rest-client', "~> 2.0"
  spec.add_dependency 'websocket-client-simple', '~> 0.3.0'
end
