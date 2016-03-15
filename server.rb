require_relative 'lib/raspberry'

class Server < EM::Connection
  extend Hardware

  def receive_data(data)
    @data = parse(data)
    data_processing if @data
  end

  private

  def parse(data)
    JSON.parse(data)
  rescue
    close
    false
  end

  def data_processing
    run(@data['action']) if @data['action']
    close
  end

  def rpi_activation
    response(serial: Server.serial, revision: Server.revision)
  end

  def ping
    response(message: 'pong')
  end

  def response(message)
    send_data message.to_json
  end

  def run(action)
    send action
  end

  def close
    close_connection_after_writing
  end

  def client_ip
    Socket.unpack_sockaddr_in(get_peername).last
  end
end
