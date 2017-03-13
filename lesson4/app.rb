require_relative('train')
require_relative('station')
require_relative('route')
require_relative('passenger_train')
require_relative('cargo_train')
require_relative('wagon')
require_relative('passenger_wagon')
require_relative('cargo_wagon')

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
  puts commands
  printf 'Введи пункт меню: '
  user_input = gets.chomp
  loop do
    case user_input
      when '1'
        create_station
      when '2'
        create_train
      when '3'
        create_route
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
  p Train::all_trains
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
  Train::all_trains.each_with_index { |train, index| puts "#{index} #{train}" }
  printf 'Выбери поезд: '
  index = gets.to_i
  Train::all_trains[index]
end

def select_route
  Route::all_routes.each_with_index { |route, index| puts "#{index} #{route.stations}" }
  printf 'Выбери маршрут: '
  index = gets.to_i
  Route::all_routes[index]
end

def select_station
  Station::all_stations.each_with_index { |station, index| puts "#{index} #{station.name}" }
  printf 'Выбери станцию: '
  index = gets.to_i
  Station::all_stations[index]
end

def add_train_wagon
  train = select_train
  wagon = train.is_a?(CargoTrain) ? CargoWagon.new : PassengerWagon.new
  train.wagon_add(wagon)
end

def remove_train_wagon
  train = select_train
  train.wagon_remove
end

def move_train
  train = select_train
  if train.route
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
  else
    puts 'Установите маршрут поезду'
  end
end

def show_station_info
  station = select_station
  puts "#{station.trains}"
end

show_menu





