require 'sinatra'
require 'json'
require 'active_record'
require 'thin'
require_relative './lib/server'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './db/settings.db'
)

def run(app)
  EM.run do
    Rack::Server.start(
      app: app, server: 'thin',
      Host: 'localhost', Port: '8081',
      signals: false)
  end
end

run App.new
