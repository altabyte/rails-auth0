# Start the puma web server
web: bundle exec puma -C config/puma.rb

# https://devcenter.heroku.com/articles/release-phase
release: bundle exec rake db:migrate

# Start any worker jobs here...
# worker: bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV
