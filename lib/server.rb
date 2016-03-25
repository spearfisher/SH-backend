require_relative 'raspberry'

class App < Sinatra::Base
  before do
    content_type :json
  end

  set(:method) { |method| condition { request.request_method == method } }
  set :salt, nil

  after '/api/*', method: 'POST' do
    settings.salt = nil
  end

  get '/api/test' do
    resp_body(message: 'OK')
  end

  get '/api/salt' do
    settings.salt = BCrypt::Engine.generate_salt
    resp_body(salt: settings.salt)
  end

  post '/api/settings' do
    resp_body raspberry
  end

  post '/api/activation' do
    raspberry.activated ? (halt 404) : rpi_activation
  end

  private

  def rpi_activation
    raspberry.activate
    resp_body(serial: raspberry.serial, revision: raspberry.revision)
  end

  def resp_body(message)
    message.to_json
  end

  def raspberry
    Raspberry.first
  end
end
