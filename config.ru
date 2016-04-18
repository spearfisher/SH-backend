Dir.chdir(File.dirname(File.expand_path(__FILE__)))
require File.join(File.dirname(__FILE__), 'app')

def run(app)
  EM.run do
    $raspberry = Raspberry.take
    $redis = Redis.new
    climate_params = EM.spawn do
      params_hash = $raspberry.climate_params
      params_hash.each { |key, value| $redis.set(key, value) }
    end

    Rack::Server.start(
      app: app, server: 'thin',
      Host: '0.0.0.0', Port: '8081',
      signals: false)

    EM.add_periodic_timer(600) do
      climate_params.notify
    end

    EM.add_periodic_timer(3600) do
      options = { 'content-length' => 0 }
      http = EventMachine::HttpRequest.new('http://home-pi.herokuapp.com/api/climate_logs/1', options).post(
                         query: { climate_log: { climate_sensor_id: 1,
                                                 datetime: Time.now.to_s,
                                                 temp: $redis.get(:temp),
                                                 humidity: $redis.get(:humidity)
                                               }.to_json })
      http.callback { p http.response }
    end
  end
end

run App.new
