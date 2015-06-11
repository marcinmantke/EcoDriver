Devise.setup do |config|
  config.mailer_sender = 'devise@example.com'
  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :get #:delete
  config.authentication_keys = [:login]
  config.scoped_views = true
  config.reset_password_keys = [:username]
  config.confirmation_keys = [:username]
  config.secret_key =
    '6c4a47ccd2e3ba7758ac7b76b03ad6839ff
    490afb88637f6bb5be62ac3fba8ccb5f40e1
    45a67c2ab76822eaf48a73170afc62f29e2e
    7537e6101214ec364fa9c'
end
