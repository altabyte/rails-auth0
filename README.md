# My Rails 5 base app

I generally fork this application when starting a new rails 5.0
[PostgreSQL](https://www.postgresql.org/) application
that requires authentication via [Auth0](https://auth0.com/).

## Setup

Be sure to set the relevant [environmental variables](#env-vars) before running this setup.

```shell
rvm install ruby-2.4.0
gem install bundler

./bin/bundle install --path=vendor/bundle

# Configure DB name environmental variables first.
./bin/rake db:setup
```

## <a name="env-vars"></a>Environmental variables

Details of the environmental variables used in this app. Examples can be seen in [.env.example](.env.example)

For local testing and development copy [.env.example](.env.example) into the following files:

* .env.development
* .env.test
* .env.staging
* .env.production


### SECRET_KEY_BASE

Your secret key is used for verifying the integrity of signed cookies.
If you change this key, all old signed cookies will become invalid!

Use the following command to generate a new sectret key:

```shell 
./bin/rails secret 
``` 

### DATABASE_NAME, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_URL

You can optionally choose to specify database config values as environmental variables
and these will over-ride those in [config/database.yml](config/database.yml). 


---

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
