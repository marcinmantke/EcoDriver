
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start

RSpec.configure do |_config|
end
