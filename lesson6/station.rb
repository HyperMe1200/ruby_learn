class Station

  include InstanceCounter

  attr_reader :name, :trains

  @@all_stations = []

  VALID_NAME = /\A[a-zа-я\d\s]{2,25}\z/i

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@all_stations << self
    register_instance
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

  def valid?
    validate!
  rescue
    false
  end

  private
  def validate!
    raise 'Некорректное имя' unless @name =~ VALID_NAME
  end
end
