#require_relative ('manufacturer')

class Wagon
  include Manufacturer
  include InstanceCounter

  def initialize
    register_instance
  end
end