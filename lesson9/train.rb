# Train class
class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  VALID_NUMBER = /\A[a-zа-я\d]{3}-?[a-zа-я\d]{2}\z/i

  attr_reader :speed, :number, :wagons
  attr_accessor :route
  validate :number, :format, VALID_NUMBER

  @@all_trains = {}

  def initialize(number)
    @number = number
    validate!
    @wagons = []
    @speed = 0
    @current_station_id = 0
    @@all_trains[number] = self
    register_instance
  end

  def self.find(number)
    @@all_trains[number]
  end

  def self.all_trains
    @@all_trains
  end

  def stop
    @speed = 0
  end

  def speedup(speed)
    @speed += speed
  end

  def slowdown(speed)
    if @speed - speed >= 0
      @speed -= speed
    else
      @speed = 0
    end
  end

  def wagon_add(wagon)
    wagon.number = wagons.size + 1
    @wagons << wagon if stopped? && wagon_valid?(wagon)
  end

  def wagon_remove
    @wagons.pop if stopped? && !@wagons.empty?
  end

  def current_station
    validate_route!
    @route.stations[@current_station_id]
  end

  def next_station
    validate_route!
    if @current_station_id == @route.stations.size - 1
      raise 'Поезд на конечной станции'
    end
    @route.stations[@current_station_id + 1]
  end

  def previous_station
    validate_route!
    raise 'Поезд на начальной станции' if @current_station_id.zero?
    @route.stations[@current_station_id - 1]
  end

  def goto_station(station)
    validate_route!
    @current_station_id = @route.stations.index(station)
  end

  def goto_next_station
    current_station.send_train(self)
    next_station.take_train(self)
    @current_station_id += 1
  end

  def goto_previous_station
    current_station.send_train(self)
    previous_station.take_train(self)
    @current_station_id -= 1
  end

  def valid?
    validate_number!
  rescue
    false
  end

  def each_wagon
    @wagons.each.with_index(1) { |wagon, index| yield(wagon, index) }
  end

  private

  def stopped?
    @speed.zero?
  end

  def validate_route!
    raise 'Необходимо задать маршрут' unless @route
    raise 'Некорректный тип данных маршрута' unless @route.is_a?(Route)
  end

  def validate_number!
    raise 'Неверный формат номера поезда' unless @number =~ VALID_NUMBER
    true
  end
end
