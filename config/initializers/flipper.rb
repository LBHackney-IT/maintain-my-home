require 'flipper/adapters/redis'

# https://github.com/jnunemaker/flipper/blob/master/docs/Optimization.md
module App
  def self.flipper
    @flipper ||= begin
                   redis = Redis::Namespace.new(:flipper, redis: Redis.new)
                   adapter = Flipper::Adapters::Redis.new(redis)
                   Flipper.new(adapter)
                 end
  end
end
