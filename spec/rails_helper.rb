# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# require 'capybara/rails'
# require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl'
require 'rspec/collection_matchers'
require 'shoulda/matchers'
require 'support/auth0_support'
require 'support/devise_support'

module Strategy

  def self.set(value)
    DatabaseCleaner.strategy = @strategy = value
    @strategy
  end

  def self.get
    @strategy
  end

  def self.truncation?
    @strategy == :truncation
  end

  def self.transaction?
    @strategy == :transaction
  end

end


# Seed the test database.
def load_seeds!
  Rails.application.load_seed
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# RoutingFilter should not be enabled in functional tests by default since the Rails router
# gets bypassed for most testcases. Having RoutingFilter enabled in this setup can cause
# missing parameters in the test environment.
#
# Routing tests can/should re-enable RoutingFilter since the whole routing stack gets executed for these testcases.
RoutingFilter.active = true

RSpec.configure do |config|

  config.before :suite do
    Strategy.set :transaction
    DatabaseCleaner.clean_with :truncation
    load_seeds!

    # Recommended usage of FactoryGirl.lint is to run this in a task before your test suite is executed.
    # Running it in a before(:suite), will negatively impact the performance of your tests when
    # running single tests.
    # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#linting-factories
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Add Devise test helpers.
  if defined? Devise
    config.include Devise::Test::ControllerHelpers,  type: :controller
    config.include Devise::Test::ControllerHelpers,  type: :view
    config.include Devise::Test::IntegrationHelpers, type: :feature
    config.include DeviseRequestSpecHelpers,         type: :request
    config.include ValidUserRequestHelper,           type: :request
    config.include RedirectUnauthenticated,          type: :controller
  end

  # Auth0 session helpers.
  config.include Auth0RequestSpecHelper

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end



Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    # with.test_framework :minitest
    # with.test_framework :minitest_4
    # with.test_framework :test_unit

    # Choose one or more libraries:
    with.library :active_record
    with.library :active_model
    with.library :action_controller
    # Or, choose the following (which implies all of the above):
    # with.library :rails
  end
end
