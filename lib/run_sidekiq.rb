require 'sidekiq-scheduler'
require File.dirname(__FILE__) + '/../worker/my_worker.rb'

# If your client is single-threaded, we just need a single connection in our Redis connection pool
Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'mykiq', :size => 1 }
end

# Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'mykiq' }
end

Sidekiq.schedule = YAML.load_file(File.expand_path("../../config/scheduler.yml", __FILE__))