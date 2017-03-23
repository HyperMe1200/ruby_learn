# CargoTrain class
class CargoTrain < Train
  private

  def wagon_valid?(wagon)
    wagon.is_a?(CargoWagon)
  end
end
