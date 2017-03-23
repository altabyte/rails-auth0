source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Must be before other gems that rely on environmental variables!
gem 'dotenv-rails', groups: [:development, :test]

gem 'rails',                                            '~> 5.0.1'
gem 'puma',                                             '~> 3.0'
gem 'pg', '~> 0.20',                                    platform: :ruby
gem 'activerecord-jdbcpostgresql-adapter',              platform: :jruby
gem 'sass-rails',                                       '~> 5.0'

# Authorization
gem 'auth0'                                             # Auth0 Ruby SDK
gem 'omniauth',                                         '~> 1.3.2'
gem 'omniauth-auth0',                                   '~> 1.4.2'

gem 'font-awesome-rails'                                # https://github.com/bokmann/font-awesome-rails
gem 'inline_svg'                                        # https://github.com/jamesmartin/inline_svg

# Javascript
gem 'coffee-rails',                                     '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',                                       '~> 5'
gem 'uglifier',                                         '>= 1.3.0'

# Rails Assets is the frictionless proxy between Bundler and Bower.
# https://rails-assets.org/#/
source 'https://rails-assets.org' do
  # gem 'rails-assets-bootstrap'
end

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

group :production, :staging do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # FactoryGirlRails must be in test AND development groups to ensure
  #   `./bin/rails g factory_girl:model ModelName`
  # generates in spec/factories and not test/factories.
  gem 'factory_girl_rails'

  gem 'faker'
  gem 'rspec-rails',                                    '~>  3.5.0'
  gem 'rspec-collection_matchers'                       # https://github.com/rspec/rspec-collection_matchers
  gem 'rspec-retry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console',                                    '>= 3.4.0'
  gem 'listen',                                         '~> 3.0.8'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring',                                         '~> 2.0.0'
  gem 'spring-watcher-listen',                          '~> 2.0.0'

  gem 'brakeman',       require: false
  gem 'rubocop',        require: false
  gem 'rubocop-rspec',  require: false
end

group :test do
  gem 'database_cleaner',                               '~> 1.5'
  gem 'shoulda-matchers',                               '~> 3.1'
  # gem 'cucumber-rails', require: false
  # gem 'selenium-webdriver'   # run Cucumber scenarios which use Javascript
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
