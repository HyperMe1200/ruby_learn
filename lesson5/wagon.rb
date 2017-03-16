#require_relative ('manufacturer')

class Wagon
  include Manufacturer
  include InstanceCounter

  def initialize
    register_instances
  end
end