class Route

  attr_reader :stations

  @@all_routes = []
  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    @@all_routes << self
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    @stations.delete(station)
  end

  def show_route
    @stations.each.with_index(1) { |station, index| puts "№#{index} #{station}" }
  end

  def self.all_routes
    @@all_routes
  end
end
