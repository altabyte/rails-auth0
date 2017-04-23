#!/usr/bin/env bash

#
# The history of the commands used while building this project.
#

rails new rails-auth0 -T --database=postgresql

./bin/bundle binstub brakeman
./bin/bundle binstub bundler-audit
./bin/bundle binstub rubocop

# Generate the .rubocop_todo.yml config file.
./bin/rubocop --auto-gen-config

# Install PostgreSQL extensions.
./bin/rails g migration add_hstore
./bin/rails g migration add_uuid

# Install RSpec
./bin/rails g rspec:install
./bin/bundle binstubs rspec-core

./bin/rails g controller PublicPages home
./bin/rails g controller Dashboard index

./bin/rails g controller auth0 callback failure --skip-template-engine --skip-assets
