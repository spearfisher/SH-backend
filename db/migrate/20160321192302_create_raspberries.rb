class CreateRaspberries < ActiveRecord::Migration
  def change
    create_table :raspberries do |t|
      t.boolean :activated, default: false
      t.boolean :camera, default: false
    end
  end
end
