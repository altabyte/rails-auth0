#
# Use the \dx command to show a list of all installed extensions.
#

require_relative 'migration_helper'

# Add Hstore extension to PostgreSQL
class AddHstore < ActiveRecord::Migration[5.0]
  include MigrationHelper

  def up
    say 'Installing Hstore extension'
    enable_extension :hstore if postgres?
  end

  def down
    say 'Removing Hstore extension'
    disable_extension :hstore if postgres?
  end
end
