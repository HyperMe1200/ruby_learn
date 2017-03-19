class Route

  include InstanceCounter

  attr_reader :stations

  @@all_routes = []
  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    @@all_routes << self
    register_instance
  end

  def add_station(station)
    validate!(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
      @stations.delete(station)
  end

  def show_route
    @stations.each.with_index(1) { |station, index| printf "№#{index} #{station.name}; " }
    puts ''
  end

  def self.all_routes
    @@all_routes
  end

  def valid?
    validate!
  rescue
    false
  end

  private
  def validate!(station = nil)
    if station
      raise 'Неверный тип данных станции' unless @stations[0].is_a?(Station) or @stations[-1].is_a?(Station)
    else
      raise 'Неверный тип данных станции' unless station.is_a?(Station)
    end
  end
end
