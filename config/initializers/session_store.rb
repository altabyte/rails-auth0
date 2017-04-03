# Be sure to restart your server when you modify this file.

# /session is the namespace
redis_session_url = "#{ENV['REDIS_URL']}/session:#{ENV.fetch('APP_NAME', 'app')}:#{Rails.env}"
Rails.application.config.session_store :redis_store, servers: [redis_session_url]
