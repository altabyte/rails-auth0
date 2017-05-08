#
# Use the \dx command to show a list of all installed extensions.
#

require_relative 'migration_helper'

# Add UUID extension to PostgreSQL
class AddUuid < ActiveRecord::Migration[5.0]
  include MigrationHelper

  def up
    say 'Installing UUID extension'
    enable_extension 'pgcrypto'  if postgres?
    enable_extension 'uuid-ossp' if postgres?
  end

  def down
    say 'Removing UUID extension'
    disable_extension 'uuid-ossp' if postgres?
    disable_extension 'pgcrypto'  if postgres?
  end
end
