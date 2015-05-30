require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module EcoDriver
  class Application < Rails::Application
    Rails.application.config.assets.precompile += %w( welcome_page.css )
    Rails.application.config.encoding = 'utf-8'
    Rails.application.config.autoload_paths += %W(#{config.root}/lib)
    Rails.application.config.i18n.default_locale = :pl
  end
end
