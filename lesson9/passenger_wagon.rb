# PassengerWagon class
class PassengerWagon < Wagon
  def occupy_capacity
    validate_capacity!
    @occupied_capacity += 1
  end
end
