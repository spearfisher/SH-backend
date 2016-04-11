Dir.chdir(File.dirname(File.expand_path(__FILE__)))
require File.join(File.dirname(__FILE__), 'app')

def run(app)
  EM.run do
    raspberry = Raspberry.first
    redis = Redis.new

    climate_params = EM.spawn do
      params_hash = raspberry.climate_params
      params_hash.each { |key, value| redis.set(key, value) }
    end

    Rack::Server.start(
      app: app, server: 'thin',
      Host: '0.0.0.0', Port: '8081',
      signals: false)

    EM.add_periodic_timer(600) do
      climate_params.notify
    end
  end
end

run App.new
