# CargoWagon class
class CargoWagon < Wagon
  def occupy_capacity(amount)
    validate_capacity!(amount)
    @occupied_capacity += amount
  end
end
