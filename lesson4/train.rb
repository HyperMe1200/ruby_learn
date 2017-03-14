class Train

  attr_reader :speed, :number, :current_station_id
  attr_accessor :route

  @@all_trains = []

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @current_station_id = 0
    @@all_trains << self
  end

  def stop
    @speed = 0
  end

  def self.all_trains
    @@all_trains
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

  def show_current_station
    puts "Текущая станция #{@route.stations[@current_station_id].name}"
  end

  def show_next_station
    puts "Следующая станция #{@route.stations[@current_station_id + 1].name}"
  end

  def show_previous_station
    if @current_station_id != 0
      puts "Предыдущая станция #{@route.stations[@current_station_id - 1].name}"
    else
      puts "Поезд на начальной станции"
    end
  end

  def goto_station(station)
    @current_station_id = @route.stations.index(station)
  end

  def goto_next_station
    if @current_station_id < @route.stations.size - 1
      next_station = @route.stations[@current_station_id + 1]
      next_station.take_train(self)
      @route.stations[@current_station_id].send_train(self)
      @current_station_id += 1
    else
      puts 'Поезд на конечной'
    end
  end

  def goto_previous_station
    if @current_station_id > 0
      previous_station = @route.stations[@current_station_id - 1]
      previous_station.take_train(self)
      @route.stations[@current_station_id].send_train(self)
      @current_station_id -= 1
    else
      puts 'Поезд на конечной'
    end
  end

  #используется только внутри методов инстанса, по условиям задачи пользователям не требуется
  private
  def stopped?
    @speed == 0
  end
end
