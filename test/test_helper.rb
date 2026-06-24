require "simplecov"
SimpleCov.start do
  add_filter "test"
end

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

# Load support files
Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
fixtures_dir = File.expand_path("fixtures", __dir__)
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  # Rails 7.1+ replaced fixture_path with fixture_paths (an array).
  ActiveSupport::TestCase.fixture_paths = [fixtures_dir]
  ActiveSupport::TestCase.file_fixture_path = fixtures_dir + "/files"
  ActiveSupport::TestCase.fixtures :all
elsif ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = fixtures_dir
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end
