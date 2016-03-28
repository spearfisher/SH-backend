require_relative 'hardware'
class Raspberry < ActiveRecord::Base
  include Hardware

  def activate
    update(activated: true)
  end

  def secret
    ENV['SECRET_KEY']
  end
end
