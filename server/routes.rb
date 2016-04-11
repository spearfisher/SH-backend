class App < Sinatra::Base
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

  post '/activation' do
    raspberry.activated ? (halt 404) : rpi_activation
  end

  post '/api/token' do
    settings.redis.expire(:stream_token, 600) if settings.redis.set(:stream_token, params[:stream_token])
    resp_body(message: 'OK')
  end
end
