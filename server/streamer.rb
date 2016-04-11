class App < Sinatra::Base
  before '/stream/:token' do
    halt 403 unless params[:token] == settings.redis.get(:stream_token)
    start_camera if `pgrep raspistill`.empty?
  end

  get '/stream/:token' do
    boundary = 'next frame'
    source = '/run/shm/pic.jpg'
    headers \
      'Cache-Control' => 'no-cache, private',
      'Content-type'  => "multipart/x-mixed-replace; boundary=--#{boundary}"
    sleep 0.1 until File.exist? source
    stream(:keep_open) do |out|
      until out.closed?
        image = IO.read(source)
        out << "--#{boundary}\r\n"
        out << "Content-type: image/jpeg\r\n"
        out << "Content-Length: #{image.length}\r\n\r\n"
        out << image
        sleep 0.01
      end
      Process.kill(:SIGINT, @pid) if out.closed? && @pid
    end
  end

  def start_camera
    # TODO: realize raspistill ruby wrapper, with configured settings
    @pid = spawn('raspistill -n -w 640 -h 480 -q 10 -o /run/shm/pic.jpg -tl 800 -t 9999999 -th 0:0:0')
    Process.detach @pid
  end
end
