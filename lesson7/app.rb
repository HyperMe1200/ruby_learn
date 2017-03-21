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
          manage_wagons
        when '6'
          move_train
        when '7'
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
    retry
  end

  private
  def commands
    %q{
       1. Создавать станции
       2. Создавать поезда
       3. Создавать маршруты и управлять станциями в нем (добавлять, удалять)
       4. Назначать маршрут поезду
       5. Управление и просмотр информации о вагонах
       6. Перемещать поезд по маршруту вперед и назад
       7. Просматривать список станций и список поездов на станции
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
    end
  end

  def manage_wagons
    puts '1. Добавить вагон'
    puts '2. Удалить вагон'
    puts '3. Отобразить информацию о вагоне'
    puts '4. Занять место в вагоне'
    puts '0. Возврат'
    printf 'Введи пункт меню:'
    user_input = gets.chomp
    case user_input
      when '1'
        add_train_wagon
      when '2'
        remove_train_wagon
      when '3'
        show_wagon_info
      when '4'
        occupy_wagon_capacity
      when '0'
        show_menu
      else
        puts 'Введен неправильный пункт меню'
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
    end
  end

  def show_wagon_info
    train = select_train
    unless train.wagons.empty?
      train.each_wagon do |wagon|
        if wagon.is_a?(PassengerWagon)
          puts "Вагон №#{wagon.number}, пассажирский, свободно #{wagon.free_capacity} мест, занято #{wagon.occupied_capacity} мест"
        else
          puts "Вагон №#{wagon.number}, грузовой, свободный объем #{wagon.free_capacity}, занятый объем#{wagon.occupied_capacity}"
        end
      end
    else
      puts 'У поезда нет вагонов'
    end
  end

  def select_wagon
    train = select_train
    unless train.wagons.empty?
      train.each_wagon do |wagon|
        puts "Вагон №#{wagon.number}"
      end
      printf 'Введи номер вагона:'
      number = gets.to_i
      train.wagons.detect { |wagon| wagon.number == number}
    else
      puts 'У поезда нет вагонов'
    end
  end

  def occupy_wagon_capacity
    wagon = select_wagon
    puts wagon.number
    if wagon.is_a?(PassengerWagon)
      wagon.occupy_capacity
      puts 'Пассажир добавлен'
    else
      printf 'Введи объем груза:'
      amount = gets.to_i
      wagon.occupy_capacity(amount)
      puts 'Груз добавлен'
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
    end
  end

  def add_train_wagon
    train = select_train
    if train.is_a?(CargoTrain)
      printf 'Введи максимальный объем:'
      capacity = gets.to_i
      train.wagon_add(CargoWagon.new(capacity))
    else
      printf 'Введи кол-во мест:'
      capacity = gets.to_i
      train.wagon_add(PassengerWagon.new(capacity))
    end
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
      station.each_train do |train|
        type = train.is_a?(PassengerTrain) ? 'Пассажирский' : 'Грузовой'
        puts "Поезд №#{train.number}, #{type}, количество вагонов #{train.wagons.length}"
      end
    else
      puts 'На станции в данный момент нет поездов'
    end
  end
end

app = Application.new
app.show_menu
