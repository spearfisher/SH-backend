require_relative 'hardware'
class Raspberry < ActiveRecord::Base
  include Hardware
  attr_reader :pid

  def activate
    update(activated: true)
  end

  def secret
    ENV['SECRET_KEY']
  end

  def start_camera
    return if raspistill_alive?
    @pid = spawn('raspistill -n -w 640 -h 480 -q 10 -o /run/shm/pic.jpg -tl 800 -t 9999999 -th 0:0:0')
    Process.detach @pid
  end

  def stop_camera
    Process.kill(:SIGINT, @pid) if @pid
    @pid = nil
  end

  def raspistill_alive?
    Process.getpgid(@pid) rescue false
  end
end
