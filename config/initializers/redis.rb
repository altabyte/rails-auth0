raise 'Redis URL not found!' unless ENV['REDIS_URL']

Redis.current = Redis.new(url: ENV['REDIS_URL'])
