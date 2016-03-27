Dir.chdir(File.dirname(File.expand_path(__FILE__)))
require File.join(File.dirname(__FILE__), 'app')

def run(app)
  EM.run do
    Rack::Server.start(
      app: app, server: 'thin',
      Host: '0.0.0.0', Port: '8081',
      signals: false)
  end
end

run App.new
