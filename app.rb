require 'sinatra'
require 'json'
require 'active_record'
require 'thin'
require_relative './lib/server'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './db/settings.sqlite3'
)

def run(app)
  EM.run do
    Rack::Server.start(
      app: app, server: 'thin',
      Host: '0.0.0.0', Port: '8081',
      signals: false)
  end
end

run App.new
