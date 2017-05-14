namespace :sessions do

  desc 'Count the number of stored sessions'
  task count: :environment do
    STDERR.puts key_pattern
    STDOUT.puts keys.count
  end
end

namespace :sessions do
  namespace :purge do

    desc 'Purge ALL stored sessions'
    task all: :environment do
      STDERR.puts "Purging ALL #{keys.count} sessions!!"
      keys.each { |key| Redis.current.del key }
    end

    desc 'Purge all sessions that have not been updated recently'
    task stale: :environment do
      STDERR.puts 'Purging stale sessions sessions...'
      count = 0
      keys.each do |key|
        session_hash = session_to_hash(Redis.current.get(key))
        if session_expired?(session_hash)
          puts "#{key}\t#{session_hash.fetch(:id_token, '')}\n\n"
          Redis.current.del key
          count += 1
        end
        puts "Purged #{count} sessions"
      end
    end
  end
end

#---------------------------------------------------------------------------
private

def key_pattern
  "session:#{ENV['APP_NAME']}:#{Rails.env}:*"
end

def keys
  Redis.current.keys(key_pattern)
end

def ttl
  ENV.fetch('SESSION_TTL', 7.days.to_i)
end

def session_expired?(session_hash)
  session_hash.fetch(:updated_at, 0).to_i + ttl < Time.now.utc.to_i
end

def session_to_hash(session)
  json = Marshal.load(session).to_s.gsub('=>', ':')
  JSON.parse(json).with_indifferent_access
end
