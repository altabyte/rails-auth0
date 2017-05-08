source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Must be before other gems that rely on environmental variables!
gem 'dotenv-rails', groups: %i[development test]

gem 'rails',                                            '~> 5.1.0'
gem 'puma',                                             '~> 3.8'
gem 'pg', '~> 0.20',                                    platform: :ruby
gem 'activerecord-jdbcpostgresql-adapter',              platform: :jruby
gem 'sass-rails',                                       '~> 5.0'
gem 'redis',                                            '~> 3.3.3'
gem 'redis-namespace',                                  '~> 1.5.3'
gem 'redis-rails',                                      '~> 5.0.2'

# TODO: routing-filter gem does not currently support Rails 5.1
# gem 'routing-filter'                                  # https://github.com/svenfuchs/routing-filter

# Authorization
gem 'auth0'                                             # Auth0 Ruby SDK
gem 'jwt'
gem 'pundit'
gem 'omniauth',                                         '~> 1.6'
gem 'omniauth-auth0',                                   '~> 2.0'

gem 'font-awesome-rails'                                # https://github.com/bokmann/font-awesome-rails
gem 'gon'                                               # https://github.com/gazay/gon
gem 'inline_svg'                                        # https://github.com/jamesmartin/inline_svg
gem 'redcarpet'                                         # https://github.com/vmg/redcarpet
# gem 'simple_form'                                     # https://github.com/plataformatec/simple_form

# Javascript
gem 'jquery-rails'
gem 'turbolinks',                                       '~> 5'
gem 'uglifier',                                         '>= 3.2'

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
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # FactoryGirlRails must be in test AND development groups to ensure
  #   `./bin/rails g factory_girl:model ModelName`
  # generates in spec/factories and not test/factories.
  gem 'factory_girl_rails'

  gem 'climate_control'                                 # https://github.com/thoughtbot/climate_control
  gem 'faker'
  gem 'rspec-rails',                                    '~>  3.6.0'
  gem 'rspec-collection_matchers'                       # https://github.com/rspec/rspec-collection_matchers
  gem 'rspec-retry'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara',                                       '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console',                                    '>= 3.5.0'
  gem 'listen',                                         '>= 3.1', '< 3.2'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring',                                         '~> 2.0'
  gem 'spring-watcher-listen',                          '~> 2.0'

  gem 'brakeman',       require: false
  gem 'rubocop',        require: false
  gem 'rubocop-rspec',  require: false

  gem 'bundler-audit',  require: false
end

group :test do
  gem 'database_cleaner',                               '~> 1.6'
  gem 'shoulda-matchers',                               '~> 3.1'
  # gem 'cucumber-rails', require: false
  # gem 'selenium-webdriver'   # run Cucumber scenarios which use Javascript
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
