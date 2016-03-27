require 'bundler'
Bundler.require
require_relative './server/helpers'
require_relative './server/routes'
require_relative './lib/raspberry'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './db/settings.sqlite3'
)

class App < Sinatra::Base
  helpers Helpers

  set(:method) { |method| condition { request.request_method == method } }
  set :salt, nil

  before do
    content_type :json
  end

  before '/api/*', method: 'POST' do
    # OPTIMIZE: use EM.defer for this long-running process
    token_verification
  end

  after '/api/*', method: 'POST' do
    settings.salt = nil
  end
end
