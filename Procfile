web bundle exec puma -C config/puma.rb config.ru
resque: QUEUES=* bundle exec rake resque:work
worker: bundle exec rake resque:work
