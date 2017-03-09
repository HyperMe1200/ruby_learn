class Route

  attr_reader :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [@first_station, @last_station]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    @stations.delete(station)
  end

  def show_route
    @stations.each_with_index { |station, index| puts "№#{index + 1} #{station}" }
  end
end

class Station

  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    @trains << train
  end

  def show_trains(train_type = 'all')
    freight_trains = []
    passenger_trains = []

    @trains.each do |train|
      if train.type == 'freight'
        freight_trains << train
      else
        passenger_trains << train
      end
    end

    case train_type
      when 'all'
        puts @trains
        puts "На станции #{@trains.length} поездов"
      when 'freight'
        puts "#{freight_trains}"
        puts "На станции #{freight_trains.length} грузовых поездов"
      when 'passenger'
        puts "#{passenger_trains}"
        puts "На станции #{passenger_trains.length} грузовых поездов"
    end
  end

  def send_train(train)
    @trains.delete(train)
  end

end

class Train

  attr_reader :carriage_amount, :speed

  def initialize(number, type, carriage_amount)
    @number = number
    @type = type
    @carriage_amount = carriage_amount
    @speed = 0
    @route = nil
    @current_station_id = 0
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

  def carriage_add
    @carriage_amount += 1 if @speed == 0
  end

  def carriage_remove
    @carriage_amount -= 1 if @speed == 0 && @carriage_amount > 0
  end

  def get_route(route)
    @route = route
  end

  def show_current_station
    puts "Текущая станция #{@route.stations[@current_station_id].name}"
  end

  def show_next_station
    puts "Следующая станция #{@route.stations[@current_station_id + 1].name}"
  end

  def show_previous_station
    if @current_station_id != 0
      puts "Предидущая станция #{@route.stations[@current_station_id - 1].name}"
    else
      puts "Поезд на начальной станции"
    end
  end

  def goto_station(station)
    @current_station_id = @route.stations.index(station)
  end
end

