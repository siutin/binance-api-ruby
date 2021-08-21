require 'bundler/setup'
require 'binance_api'
require 'vcr'
require 'pry'

# change to your profile at config/config.yml
config = YAML.load_file(File.join(__dir__, '..', 'config', 'config.yml'))
BinanceAPI.api_key = config['API_KEY']
BinanceAPI.api_secret = config['API_SECRET']

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.before(:each, :vcr) do |test|
    select_or_create_vcr_cassette(test_name: test.description, full_test_context: self.class.name)
  end

  config.after(:each, :vcr) do
    VCR.eject_cassette
  end
end

def select_or_create_vcr_cassette(test_name: ,full_test_context:)
  full_path = full_test_context.gsub('::', '/') + "/#{test_name}"
  full_path.slice!('RSpec/ExampleGroups/')
  VCR.insert_cassette(
    full_path,
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_params('signature', 'timestamp')]
  )
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }
