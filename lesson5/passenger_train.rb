class PassengerTrain < Train

  #необходим только для реализации метода добавления вагона
  private
  def wagon_valid?(wagon)
    wagon.class == PassengerWagon
  end
end
