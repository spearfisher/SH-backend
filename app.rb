require 'sinatra'
require 'sinatra/activerecord'
require 'thin'
require_relative 'server'

EM.run do
  Thin::Server.start(Server, '', 8081)
  Signal.trap('INT') { EM.stop }
  Signal.trap('TERM') { EM.stop }
end
