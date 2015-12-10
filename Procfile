web: bundle exec passenger start --nginx-config-template nginx.conf.erb -p $PORT --max-pool-size $WEB_CONCURRENCY
worker: bundle exec rake que:work
