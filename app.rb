require 'eventmachine'
require 'json'
require_relative 'server'

EM.run do
  EM.start_server('', 8081, Server)
end
