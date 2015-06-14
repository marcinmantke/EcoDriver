require 'simplecov'
require 'simplecov-rcov'
require 'capybara'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start

Capybara.register_driver :chrome do |app|
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.timeout = 240
  Capybara::Selenium::Driver.new(app, browser: :chrome,
                                      http_client: http_client)
end

Capybara.current_driver = :chrome

RSpec.configure do |config|
  config.before(:suite) do
    @headless = Headless.new
    @headless.start
  end

  config.after(:suite) do
    @headless.destroy
  end
end
