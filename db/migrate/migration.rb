require 'active_record'
require_relative '../../lib/raspberry'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './db/settings.db'
)

class CreateRaspberries < ActiveRecord::Migration
  def change
    create_table :raspberries do |t|
      t.boolean :activated, default: false
      t.boolean :camera, default: false
    end
  end
end

# Create table
CreateRaspberries.migrate(:change) unless Raspberry.table_exists?

# Seed database
raspberry = Raspberry.first || Raspberry.new
raspberry.update(activated: false, camera: false)
