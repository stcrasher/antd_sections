ENV['RAILS_ENV'] ||= 'test_features'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'site_prism'
require 'faker/formatted_phone_number'
require 'capybara/apparition'
Sequel::Model.db.extension(:null_dataset)

Dir[Rails.root.join('spec.features/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  Faker::Config.locale = 'en-GB'
  config.include FactoryGirl::Syntax::Methods
  config.include WaitUntilTrueHelper
  config.include VerboseHelper
  config.use_transactional_fixtures = false
  config.verbose_retry = true
  config.display_try_failure_messages = true

  config.before(:suite) do
    DatabaseCleaner[:sequel].strategy = :truncation, {except: %w[]}
    DatabaseCleaner[:sequel].db = DB
    DatabaseCleaner[:sequel].clean_with(:truncation, except: %w[])
    Rails.application.load_seed
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    Rails.application.load_seed
    DatabaseCleaner[:sequel].start
  end

  config.around(:each) do |example|
    retries = ENV['CI'] ? 2 : 0
    example.run_with_retry(retry: retries)
  end

  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end
end

Capybara.run_server = false
Capybara.app_host = 'http://test.me:3030'
Capybara.default_max_wait_time = 10
Capybara.reuse_server = false
Capybara.automatic_reload = true
Capybara.default_normalize_ws = true
Capybara.save_path = Rails.root.join('tmp/capybara')

Capybara.register_driver :apparition do |app|
  options = {
    headless: ENV['HEADLESS'].present?,
    timeout: 60,
    window_size: [1920, 2160],
    screen_size: [1920, 2160],
    js_errors: false,
    browser_logger: UITest::UILogger.new(Rails.root.join('log/browser_logger.log')),
    browser_options: {'disable-web-security': nil} # Disable CORS
  }
  Capybara::Apparition::Driver.new(app, options)
end

Capybara.default_driver = :apparition
Capybara.javascript_driver = :apparition

Capybara::Screenshot.prune_strategy = :keep_last_run
