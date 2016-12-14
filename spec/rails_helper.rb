# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
# require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/shared_contexts/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/shared_examples/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/macros/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/macros/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
RSpec.configure do |config|

  [:controller, :view, :request].each do |type|
    config.include ::Rails::Controller::Testing::TestProcess, type: type
    config.include ::Rails::Controller::Testing::TemplateAssertions, type: type
    config.include ::Rails::Controller::Testing::Integration, type: type
  end

  # Capybara.javascript_driver = :webkit
  Capybara.page.driver.header('HTTP_ACCEPT_LANGUAGE', 'en')
  Capybara.ignore_hidden_elements = false
  config.include AbstractController::Translation

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.after(:suite) do
    FileUtils.rm_rf Rails.root.join("public/uploads#{ENV['TEST_ENV_NUMBER'] || ''}")
  end
end
