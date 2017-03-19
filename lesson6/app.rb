require_relative('instance_counter')
require_relative('manufacturer')
require_relative('train')
require_relative('station')
require_relative('route')
require_relative('passenger_train')
require_relative('cargo_train')
require_relative('wagon')
require_relative('passenger_wagon')
require_relative('cargo_wagon')

class Application

  def show_menu
    puts commands #.gsub(/^#{commands.scan(/^[ \t]+(?=\S)/).min}/, '')
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
  rescue Exception => e
    puts e.message
    puts e.backtrace
    retry
  end

  private
  def commands
    %q{
       1. Создавать станции
       2. Создавать поезда
       3. Создавать маршруты и управлять станциями в нем (добавлять, удалять)
       4. Назначать маршрут поезду
       5. Добавлять вагоны к поезду
       6. Отцеплять вагоны от поезда
       7. Перемещать поезд по маршруту вперед и назад
       8. Просматривать список станций и список поездов на станции
       0. Выход
    }
  end

  def create_station
    printf 'Введите имя станции: '
    name = gets.chomp
    puts "Станция #{name} создана"
    Station.new(name)
  end

  def create_train
    printf 'Выбери тип поезда: 1. Пассажирский, 2. Грузовой : '
    type = gets.chomp
    printf 'Введи номер поезда: '
    number = gets.chomp
    case type
      when '1'
        PassengerTrain.new(number)
        puts "Пассажирский поезд №#{number} создан"
      when '2'
        CargoTrain.new(number)
        puts "Грузовой поезд №#{number} создан"
      else
        puts 'Неправильный ввод'
    end
  end

  def add_route_station(route)
    station = create_station
    route.add_station(station)
    puts "Станция #{station.name} добавлена к маршруту"
    route.show_route
  end

  def remove_route_station(route)
    route.show_route
    puts 'Введи номер станции: '
    station_index = gets.to_i - 1
    station = route.stations[station_index]
    if route.stations.index(station) == 0 || route.stations.index(station) == route.stations.length - 1
      puts 'Нельзя удалять начальную и конечную станции маршрута'
    else
      route.remove_station(station)
      puts 'Станция удалена из маршрута'
    end
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
    puts 'Маршрут создан'
  end

  def add_train_route
    train = select_train
    train.route = select_route
    puts "Маршрут назначен поезду №#{train.number}"
  end

  def select_train
    unless Train.all_trains.empty?
      trains = Train.all_trains.values
      trains.each_with_index{ |train, index| puts "#{index}. Поезд №#{train.number}" }
      printf 'Выбери поезд: '
      index = gets.to_i
      trains[index]
    else
      puts 'Необходимо создать поезд'
      show_menu
    end
  end

  def select_route
    unless Route.all_routes.empty?
      Route.all_routes.each_with_index { |route , index| printf "#{index}. "; route.show_route}
      printf 'Выбери маршрут: '
      index = gets.to_i
      Route.all_routes[index]
    else
      puts 'Необходимо создать маршрут'
      show_menu
    end
  end

  def select_station
    unless Station.all_stations.empty?
      Station.all_stations.each_with_index { |station, index| puts "#{index}. #{station.name}" }
      printf 'Выбери станцию: '
      index = gets.to_i
      Station.all_stations[index]
    else
      puts 'Необходимо создать станцию'
      show_menu
    end
  end

  def add_train_wagon
    train = select_train
    wagon = train.is_a?(CargoTrain) ? CargoWagon.new : PassengerWagon.new
    train.wagon_add(wagon)
    puts 'Вагон добавлен'
    puts "Кол-во вагонов в поезде: #{train.wagons.size}"
  end

  def remove_train_wagon
    train = select_train
    if train.wagons.length > 0
      train.wagon_remove
      puts 'Вагон удален'
    else
      puts 'У поезда нет вагонов'
    end
  end

  def move_train
    train = select_train
    if train.route
      puts "Текущая станция: #{train.current_station.name}"
      printf 'Выбирите направление движения: 1. Вперед, 2. Назад : '
      direction = gets.chomp
      case direction
        when '1'
          train.goto_next_station
          puts "Поезд перемещен на станцию #{train.current_station.name}"
        when '2'
          train.goto_previous_station
          puts "Поезд перемещен на станцию #{train.current_station.name}"
        else
          puts 'Неправильный ввод'
      end
    else
      puts 'Установите маршрут поезду'
    end
  end

  def show_station_info
    station = select_station
    unless station.trains.empty?
      station.trains.each {|train| puts "Поезд №#{train.number}"}
    else
      puts 'На станции в данный момент нет поездов'
    end
  end
end

app = Application.new
app.show_menu
