namespace :sessions do

  desc 'Purge all sessions that have not been updated in at least 7 days'
  task purge: :environment do
    begin
      key_prefix = "session:#{ENV['APP_NAME']}:#{Rails.env}"
      keys = Redis.current.keys.select { |key| key.starts_with? key_prefix }
      keys.each do |key|
        session = Redis.current.get key
        next unless session
        destroy_session(key, session)
      end
    rescue => e
      puts e
    end
  end

  #---------------------------------------------------------------------------
  private

  def verbose?
    true
  end

  def ttl
    ENV.fetch('SESSION_TTL', 7.days.to_i)
  end

  def destroy_session(key, session)
    print key if verbose?
    json = Marshal.load(session).to_s.gsub('=>', ':')
    hash = JSON.parse(json)
    return unless hash.key? 'updated_at'
    updated_at = hash['updated_at'].to_i
    if updated_at + ttl < Time.now.utc.to_i
      Redis.current.del key
      print ', DESTROYED' if verbose?
    end
    print "\n"
  end
end
