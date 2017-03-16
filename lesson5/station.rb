class Station

  include InstanceCounter

  attr_reader :name, :trains

  @@all_stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@all_stations << self
    register_instances
  end

  def take_train(train)
    @trains << train
  end

  def show_trains(train_type)
    @trains.select { |train| train.class == train_type }
  end

  def send_train(train)
    @trains.delete(train)
  end

  def self.all_stations
    @@all_stations
  end
end
