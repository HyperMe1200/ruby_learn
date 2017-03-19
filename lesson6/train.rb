class Train

  include Manufacturer
  include InstanceCounter

  attr_reader :speed, :number, :wagons
  attr_accessor :route

  @@all_trains = {}

  VALID_NUMBER = /\A[a-zа-я\d]{3}-?[a-zа-я\d]{2}\z/i

  def initialize(number)
    @number = number
    validate_number!
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
    @wagons << wagon if stopped? && wagon_valid?(wagon)
  end

  def wagon_remove
    @wagons.pop if stopped? && @wagons.length > 0
  end

  def current_station
    validate_route!
    @route.stations[@current_station_id]
  end

  def next_station
    validate_route!
    raise 'Поезд на конечной станции' if @current_station_id == @route.stations.size - 1
    @route.stations[@current_station_id + 1]
  end

  def previous_station
    validate_route!
    raise 'Поезд на начальной станции' if @current_station_id == 0
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

  #используется только внутри методов инстанса, по условиям задачи пользователям не требуется
  private
  def stopped?
    @speed == 0
  end

  def validate_route!
    raise 'Необходимо задать маршрут' unless @route
    raise 'Некорректный тип данных маршрута' unless @route.is_a?(Route)
  end

  def validate_number!
    raise 'Неверный формат номера поезда' if @number !~ VALID_NUMBER
    true
  end
end
