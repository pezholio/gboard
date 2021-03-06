require 'coveralls'
Coveralls.wear!

require 'gboard'
require 'webmock/rspec'
require 'support/vcr_setup'
require 'timecop'

ENV['RECIPIENT_EMAILS'] = "foo@example.com,bar@example.com"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
