# PassengerTrain class
class PassengerTrain < Train
  private

  def wagon_valid?(wagon)
    wagon.is_a?(PassengerWagon)
  end
end
