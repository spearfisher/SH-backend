module Hardware
  def serial
    get_value 'Serial'
  end

  def revision
    get_value 'Revision'
  end

  def model_name
    get_value 'model name'
  end

  private

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
