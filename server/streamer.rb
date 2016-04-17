class App < Sinatra::Base
  before '/stream/:token' do
    halt 403 unless params[:token] == $redis.get(:stream_token)
    $raspberry.start_camera
  end

  get '/stream/:token' do
    boundary = 'next frame'
    source = '/run/shm/pic.jpg'
    headers \
      'Cache-Control' => 'no-cache, private',
      'Content-type'  => "multipart/x-mixed-replace; boundary=--#{boundary}"
    sleep 0.1 until File.exist? source
    stream(:keep_open) do |out|
      settings.connections << out
      until out.closed?
        image = IO.read(source)
        out << "--#{boundary}\r\n"
        out << "Content-type: image/jpeg\r\n"
        out << "Content-Length: #{image.length}\r\n\r\n"
        out << image
        sleep 0.01
      end
      out.callback { settings.connections.delete(out) }
      $raspberry.stop_camera if settings.connections.empty?
    end
  end
end
