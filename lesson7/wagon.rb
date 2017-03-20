class Wagon
  include Manufacturer
  include InstanceCounter

  attr_accessor :number
  attr_reader :capacity, :occupied_capacity

  def initialize(capacity)
    @capacity = capacity
    @occupied_capacity = 0
    register_instance
  end

  def free_capacity
    @capacity - @occupied_capacity
  end

  def occupy_capacity
    raise 'Необходимо реализовать метод в подклассе'
  end

  private
  def validate_capacity!(amount = 1)
    raise 'В вагоне недостаточно места' if @capacity < @occupied_capacity + amount
  end
end
