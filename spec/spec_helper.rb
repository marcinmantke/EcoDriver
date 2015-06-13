
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start

RSpec.configure do |config|
  config.before(:suite) do
    @headless = Headless.new
    @headless.start
  end

  config.after(:suite) do
    @headless.destroy
  end
end
