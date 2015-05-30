Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.js_compressor = :uglifier
  config.assets.js_compressor = Uglifier.new(mangle: false)
  config.assets.compile = true
  config.assets.precompile =
    ['*.js', '*.css', '*.css.erb', '*.coffee', '*.sass', '*.scss']
  config.assets.digest = true
  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  #config.i18n.available_locales = [:pl, :en]
end
