raspberry = Raspberry.first || Raspberry.new

raspberry.update(activated: false, camera: false)
