require_relative 'lib/raspberry'

class Server < Sinatra::Base
  extend Hardware

  before do
    content_type :json
  end

  get '/api/test' do
    resp_body(message: 'OK')
  end

  get '/api/activation' do
    rpi_activation
  end

  private

  def rpi_activation
    res(serial: Server.serial, revision: Server.revision)
  end

  def resp_body(message)
    message.to_json
  end
end
