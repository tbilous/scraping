require 'rails_helper'
require 'capybara/poltergeist'
require 'puma'
# require 'selenium-webdriver'

RSpec.configure do |config|
  include ActionView::RecordIdentifier
  #
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90, js_errors: true,
      phantomjs_logger: Logger.new(STDOUT),
      window_size: [1920, 6000]
    )
  end

  config.before(:each) do
    if Capybara.current_driver == :poltergeist
      page.driver.headers = { 'Accept-Language' => 'en-IE' }
    end
  end

  Capybara.ignore_hidden_elements = false
  Capybara.javascript_driver = :poltergeist
  # Capybara.javascript_driver = :webkit
  # Capybara.javascript_driver = :selenium
  Capybara.page.driver.header('HTTP_ACCEPT_LANGUAGE', 'en')

  Capybara.server = :puma

  config.use_transactional_fixtures = false

  # config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  #
  # config.before(:each) { DatabaseCleaner.strategy = :transaction }

  # config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  #
  # config.before(:each, type: :feature) { Capybara.app_host = "http://dev.#{Capybara.server_host}.xip.io" }

  # config.before(:each) { DatabaseCleaner.start }

  config.after(:each) { Timecop.return }

  config.append_after(:each) do
    Capybara.reset_sessions!
    # DatabaseCleaner.clean
  end
end
