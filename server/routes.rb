class App < Sinatra::Base
  get '/api/test' do
    resp_body(message: 'OK')
  end

  get '/api/salt' do
    settings.salt = BCrypt::Engine.generate_salt 12
    resp_body(salt: settings.salt)
  end

  post '/api/settings' do
    resp_body raspberry
  end

  post '/activation' do
    raspberry.activated ? (halt 404) : rpi_activation
  end
end