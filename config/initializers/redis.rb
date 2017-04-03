raise 'Redis URL not found!' unless ENV['REDIS_URL']

$redis = Redis.new(url: ENV['REDIS_URL'])
