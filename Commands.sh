#!/usr/bin/env bash

#
# The history of the commands used while building this project.
#

rails new rails-auth0 -T --database=postgresql

# Generate the .rubocop_todo.yml config file.
rubocop --auto-gen-config

# Install PostgreSQL extensions.
./bin/rails g migration add_hstore
./bin/rails g migration add_uuid
