class CargoTrain < Train

  #необходим только для реализации метода добавления вагона
  private
  def wagon_valid?(wagon)
    wagon.class == CargoWagon
  end
end