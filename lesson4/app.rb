require_relative('train')
require_relative('station')
require_relative('route')
require_relative('passenger_train')
require_relative('cargo_train')
require_relative('wagon')
require_relative('passenger_wagon')
require_relative('cargo_wagon')

class Application

  def initialize
    show_menu
  end

  private
  def commands
    '1. Создавать станции
     2. Создавать поезда
     3. Создавать маршруты и управлять станциями в нем (добавлять, удалять)
     4. Назначать маршрут поезду
     5. Добавлять вагоны к поезду
     6. Отцеплять вагоны от поезда
     7. Перемещать поезд по маршруту вперед и назад
     8. Просматривать список станций и список поездов на станции
     0. Выход'
  end

  def show_menu
    puts ''
    puts commands.gsub(/^#{commands.scan(/^[ \t]+(?=\S)/).min}/, '')
    printf 'Введи пункт меню: '
    user_input = gets.chomp
    loop do
      case user_input
        when '1'
          create_station
        when '2'
          create_train
        when '3'
          manage_route
        when '4'
          add_train_route
        when '5'
          add_train_wagon
        when '6'
          remove_train_wagon
        when '7'
          move_train
        when '8'
          show_station_info
        when '0'
          exit!
        else
          puts 'Введен некорректный пункт меню'
      end
    show_menu
    end
  end

  def create_station
    printf 'Введите имя станции: '
    name = gets.chomp
    Station.new(name)
  end

  def create_train
    printf 'Введи номер поезда: '
    number = gets.to_i
    printf 'Выбери тип поезда: 1. Пассажирский, 2. Грузовой : '
    type = gets.chomp
    case type
      when '1'
        PassengerTrain.new(number)
      when '2'
        CargoTrain.new(number)
      else
        puts 'Неправильный ввод'
    end
  end

  def add_route_station(route)
    printf 'Введи имя станции: '
    name = gets.chomp
    station = Station.new(name)
    route.add_station(station)
    puts 'Станция добавлена'
  end

  def remove_route_station(route)
    route.show_route
    puts 'Введи номер станции: '
    station_index = gets.to_i - 1
    station = route.stations[station_index]
    route.remove_station(station)
    puts 'Станция удалена из маршрута'
  end

  def change_route
    route = select_route
    puts '1. Добавить станцию'
    puts '2. Удалить станцию'
    puts '0. Возврат'
    printf 'Введи пункт меню: '
    user_input = gets.chomp
    case user_input
      when '1'
        add_route_station(route)
      when '2'
        remove_route_station(route)
      when '0'
        show_menu
      else
        puts 'Введен неправильный пункт меню'
        show_menu
    end
  end

  def manage_route
    puts '1. Добавить маршрут'
    puts '2. Изменить маршрут'
    puts '0. Возврат'
    printf 'Введи пункт меню:'
    user_input = gets.chomp
    case user_input
      when '1'
        create_route
      when '2'
        change_route
      when '0'
        show_menu
      else
        puts 'Введен неправильный пункт меню'
        show_menu
    end
  end

  def create_route
    printf 'Введи название начальной станции маршрута: '
    first_station = Station.new(gets.chomp)
    printf 'Введи название конечной станции маршрута: '
    last_station = Station.new(gets.chomp)
    Route.new(first_station, last_station)
  end

  def add_train_route
    train = select_train
    train.route = select_route
  end

  def select_train
    Train.all_trains.each_with_index { |train, index| puts "#{index}. поезд №#{train.number}" }
    printf 'Выбери поезд: '
    index = gets.to_i
    Train.all_trains[index]
  end

  def select_route
    Route.all_routes.each_with_index { |route , index| printf "#{index}. "; route.show_route}
    printf 'Выбери маршрут: '
    index = gets.to_i
    Route.all_routes[index]
  end

  def select_station
    Station.all_stations.each_with_index { |station, index| puts "#{index}. #{station.name}" }
    printf 'Выбери станцию: '
    index = gets.to_i
    Station.all_stations[index]
  end

  def add_train_wagon
    train = select_train
    wagon = train.is_a?(CargoTrain) ? CargoWagon.new : PassengerWagon.new
    train.wagon_add(wagon)
    puts "Кол-во вагонов в поезде: #{train.wagons.size}"
  end

  def remove_train_wagon
    train = select_train
    train.wagon_remove
  end

  def move_train
    train = select_train
    if train.route
      train.show_current_station
      printf 'Выбирите направление движения: 1. Вперед, 2. Назад : '
      direction = gets.chomp
      case direction
        when '1'
          train.goto_next_station
        when '2'
          train.goto_previous_station
        else
          puts 'Неправильный ввод'
      end
      train.show_current_station
    else
      puts 'Установите маршрут поезду'
    end
  end

  def show_station_info
    station = select_station
    puts "#{station.trains}"
  end
end

Application.new







