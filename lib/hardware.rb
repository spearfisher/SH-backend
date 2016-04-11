module Hardware
  def serial
    get_value 'Serial'
  end

  def revision
    get_value 'Revision'
  end

  def climate_params
    garbage_collector fetch_sensor_values
  end

  private

  def fetch_sensor_values
    5.times.collect { DhtSensor.read(4, 22) }
  end

  def garbage_collector(params)
    temp, rh = [], []
    params.each do |sensor|
      temp << sensor.temp
      rh << sensor.humidity
    end
    { temp: temp.sort[temp.length / 2],
      humidity: rh.sort[rh.length / 2] }
  end

  # get cpuinfo list
  def cpuinfo
    IO.readlines('/proc/cpuinfo')
  end

  # get information from cpuinfo
  def get_value(value)
    line = cpuinfo.grep(/^#{value}*/).first
    line.chomp!
    /\w*$/.match(line).to_s
  end
end
