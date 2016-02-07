require 'vcr'
require_relative 'ignore_env'

VCR.configure do |c|
  (ENV.keys-$ignore_env).select{|x| x =~ /\A[A-Z_]*\Z/}.each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
  c.cassette_library_dir = 'fixtures/rspec/vcr'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :all }
  c.allow_http_connections_when_no_cassette = false

  c.configure_rspec_metadata!
end
