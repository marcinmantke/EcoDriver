
require 'simplecov'
require 'simplecov-rcov'
require 'capybara'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start

Capybara.register_driver :chrome do |app|
 Capybara::Selenium::Driver.new(app, :browser => :chrome)
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
