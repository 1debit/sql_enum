require "bundler/setup"
require "sql_enum"

require 'debug'
require "awesome_print"

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # allow "fit" examples
  config.filter_run_when_matching :focus
  config.include DefineConstantMacros

  config.before(:all) do
    ActiveRecord::Base.establish_connection(ENV.fetch('DATABASE_URL'))
  end

  config.after do
    clear_generated_tables
  end
end
