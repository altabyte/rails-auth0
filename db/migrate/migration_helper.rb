# Helper methods for rails migrations.
#
module MigrationHelper

  # Determine if using PostgreSQL database.
  def postgres?
    ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
  end

  # Determine if using MySQL database.
  def mysql?
    ActiveRecord::Base.connection.adapter_name == 'MySQL'
  end

end
