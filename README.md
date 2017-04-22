# My Rails 5 base app

This is a bare-bones Rails 5 [PostgreSQL](https://www.postgresql.org/) application with authentication
handled by [Auth0](https://auth0.com/). I generally fork this repo when starting a new web application.

This application uses [Redis](https://redis.io/) for the [session store](config/initializers/session_store.rb).
My preferred redis hosting is [Redis Cloud](https://redislabs.com/), which is available as a
[Heroku addon](https://elements.heroku.com/addons/rediscloud).

## Setup

Install [Ruby](https://www.ruby-lang.org/) and the [Bundler](http://bundler.io/) gem if necessary.

If using the [RVM](https://rvm.io/) Ruby Version Manager...

```shell
rvm install ruby-2.4.1
gem install bundler
```

**or**, if you prefer [rbenv](https://github.com/rbenv/rbenv)...

```shell
brew install rbenv
rbenv install 2.4.1
gem install bundler
```

Be sure to set the relevant [environmental variables](#env-vars) before running the following setup.

```shell
./bin/bundle install --path=vendor/bundle

# Configure DB name environmental variables first.
./bin/rake db:setup
```

## Rebranding

To rebrand this application for your own purposes, it is recommended to change the module name from `RailsAuth0`
to something more relevant in [config/application.rb](config/application.rb).

You will also need to change the database connection parameters in [config/database.yml](config/database.yml)
or set them using environmental variables.

## Environmental variables <a name="env-vars"></a>

Example values of the environmental variables used in this app can be found in [`.env.example`](.env.example)

For local testing and development copy and customize [.env.example](.env.example) into the following files:

* `.env.development`
* `.env.test`
* `.env.staging`
* `.env.production`


### APP_NAME

An identifier name for this app. This is to be used internally by the app
in situations such as session key identifier and [S3](https://aws.amazon.com/s3/) paths.
This should only contain URL safe characters and no spaces.

### SECRET_KEY_BASE

Your secret key is used for verifying the integrity of signed cookies.
If you change this key, all old signed cookies will become invalid!

Use the following command to generate a new secret key:

```shell 
./bin/rails secret 
``` 

### FORCE_SSL
A boolean switch to determine if SSL connections should be forced. When active this 
will redirect `http://` requests to `https://`.
Acceptable values are `true` and `false`. If this environmental variable is not
defined, **false** is assumed.

### DATABASE_URL

The database connection URL if deployed on platforms such as [Heroku](https://www.heroku.com/).

You can optionally choose to specify the following database config values as environmental variables
if you prefer not to put them in [config/database.yml](config/database.yml).

  1. DATABASE_NAME

  2. DATABASE_USERNAME

  3. DATABASE_PASSWORD

### AUTH0_DOMAIN

Auth0 client application domain. You can find this in the [clients](https://manage.auth0.com/#/clients) 
section of your Auth0 account. This will be a string similar to `my-app-name.auth0.com`.

### AUTH0_CLIENT_ID

The ID of your Auth0 client.

### AUTH0_CLIENT_SECRET

The Auth0 client application secret - A.K.A. password.

**Note:** It is good practice to [Rotate](https://auth0.com/docs/api/management/v2#!/Clients/post_rotate_secret)
your client secret frequently.

### AUTH0_CALLBACK_URL

The callback URL to be called after a user has logged in or signed up. For development use
`'http://localhost:3000/auth/auth0/callback'`

## Testing

```shell
./bin/rspec
```

## Code Style

Source code consistency is checked by [Rubocop](http://batsov.com/rubocop/).
RuboCop is a Ruby code style checker based on the community-driven
[Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide).

A Rubocop check is executed by [GitLab CI](https://about.gitlab.com/gitlab-ci/) before each build.

### Check Your Code

You can check your code locally:

```shell
./bin/rubocop
```

### Fix Your Code

Rubocop can try to [automatically](https://github.com/bbatsov/rubocop/wiki/Automatic-Corrections)
fix your code with the following command.

```shell
./bin/rubocop -a
```

This will try to fix issues in new files.

## Security Tools

Run [Brakeman](http://brakemanscanner.org/) before each deploy with the following command:

```shell
./bin/brakeman
```
Brakeman is an open source vulnerability scanner specifically designed for Ruby on Rails applications.
It statically analyzes Rails application code to find security issues at any stage of development.
