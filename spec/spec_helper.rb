# frozen_string_literal: true

require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start do
  add_filter 'spec/support/'
end

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require "bundler/setup"
require "pry"
require "pry-byebug"
require "pry-state"
require "active_support/all"

require "aws_cron"

Dir[File.join(File.dirname(__FILE__), "support/shared_contexts/**/*.rb")].each { |file| require file }

RSpec.configure do |config|
  config.order = "random"
  config.disable_monkey_patching!
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "./tmp/rspec-status.txt"
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.expose_dsl_globally = true

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  $stdout = File.new("/dev/null", "w") if ENV["SUPPRESS_STDOUT"] == "enabled"
  $stderr = File.new("/dev/null", "w") if ENV["SUPPRESS_STDERR"] == "enabled"
end
