# Station class
class Station
  include InstanceCounter
  include Validation

  VALID_NAME = /\A[a-zа-я\d\s]{2,25}\z/i

  attr_reader :name, :trains
  validate :name, :format, VALID_NAME
  @@all_stations = []



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
    validate_name!
  rescue
    false
  end

  def each_train
    @trains.each { |train| yield(train) }
  end

  private

  def validate_name!
    raise 'Некорректное имя' unless @name =~ VALID_NAME
  end
end
