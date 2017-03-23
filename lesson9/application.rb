require_relative('instance_counter')
require_relative('manufacturer')
require_relative('helper')
require_relative('validation')
require_relative('train')
require_relative('station')
require_relative('route')
require_relative('passenger_train')
require_relative('cargo_train')
require_relative('wagon')
require_relative('passenger_wagon')
require_relative('cargo_wagon')

# Application class
class Application
  include Helper

  def show_menu
    loop do
      menu
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  private

  def menu
    puts '------------------------------------------'
    commands.each { |key, command| puts "#{key}. #{command[:name]}" }
    print_prompt
    key = user_input
    if commands.key?(key)
      send(commands[key][:method])
    else
      print_wrong_input
    end
  end

  def commands
    {
      1 => { name: 'Создавать станции', method: :create_station },
      2 => { name: 'Создавать поезда', method: :create_train },
      3 => { name: 'Управлять маршрутами', method: :manage_route },
      4 => { name: 'Назначать маршрут поезду', method: :add_train_route },
      5 => { name: 'Управление вагонами', method: :manage_wagons },
      6 => { name: 'Перемещать поезд', method: :move_train },
      7 => { name: 'Информация о станциях', method: :show_station_info },
      0 => { name: 'Выход', method: :exit! }
    }
  end

  def create_station
    printf 'Введите имя станции: '
    name = user_input('str')
    puts "Станция #{name} создана"
    Station.new(name)
  end

  def train_type_menu
    {
      1 => 'Пассажиский поезд',
      2 => 'Грузовой поезд'
    }
  end

  def create_train
    printf 'Введи номер поезда: '
    number = user_input('str')
    case user_choice(train_type_menu)
    when 1
      PassengerTrain.new(number)
      puts "Пассажирский поезд №#{number} создан"
    when 2
      CargoTrain.new(number)
      puts "Грузовой поезд №#{number} создан"
    end
  end

  def add_route_station(route)
    station = create_station
    route.add_station(station)
    puts "Станция #{station.name} добавлена к маршруту"
    route.show_route
  end

  def removable_station?(station, route)
    ![0, route.stations.length - 1].include?(route.stations.index(station))
  end

  def remove_route_station(route)
    route.show_route
    printf 'Введи номер станции: '
    station = route.stations[user_input - 1]
    if removable_station?(station, route)
      route.remove_station(station)
      puts 'Станция удалена из маршрута'
    else
      puts 'Нельзя удалять начальную и конечную станции маршрута'
    end
  end

  def change_route_station_menu
    {
      1 => 'Добавить станцию',
      2 => 'Удалить станцию',
      0 => 'Возврат'
    }
  end

  def change_route
    route = select_route
    case user_choice(change_route_station_menu)
    when 1 then add_route_station(route)
    when 2 then remove_route_station(route)
    when 0
      show_menu
    end
  end

  def manage_wagons_menu
    {
      1 => 'Добавить вагон',
      2 => 'Удалить вагон',
      3 => 'Отобразить информацию о вагоне',
      4 => 'Занять место в вагоне',
      0 => 'Возврат'
    }
  end

  def manage_wagons
    case user_choice(manage_wagons_menu)
    when 1 then add_train_wagon
    when 2 then remove_train_wagon
    when 3 then show_wagon_info
    when 4 then occupy_wagon_capacity
    when 0 then show_menu
    end
  end

  def manage_route_menu
    {
      1 => 'Добавить маршрут',
      2 => 'Изменить маршрут',
      0 => 'Возврат'
    }
  end

  def manage_route
    case user_choice(manage_route_menu)
    when 1 then create_route
    when 2 then change_route
    when 0 then show_menu
    end
  end

  def create_route
    printf 'Введи название начальной станции маршрута: '
    first_station = Station.new(user_input('str'))
    printf 'Введи название конечной станции маршрута: '
    last_station = Station.new(user_input('str'))
    Route.new(first_station, last_station)
    puts 'Маршрут создан'
  end

  def add_train_route
    train = select_train
    return unless train.route
    train.route = select_route
    puts "Маршрут назначен поезду №#{train.number}"
  end

  def select_train
    if Train.all_trains.empty?
      puts 'Необходимо создать поезд'
      show_menu
    else
      trains = Train.all_trains.values
      trains.each_with_index { |t, i| puts "#{i}. Поезд №#{t.number}" }
      printf 'Выбери поезд: '
      index = user_input
      trains[index]
    end
  end

  def wagon_info(train)
    train.each_wagon do |wagon|
      if wagon.is_a?(PassengerWagon)
        puts "Вагон №#{wagon.number}, пассажирский, свободно \
          #{wagon.free_capacity} мест, занято #{wagon.occupied_capacity} мест"
      elsif wagon.is_a?(CargoWagon)
        puts "Вагон №#{wagon.number}, грузовой, свободный \
          объем #{wagon.free_capacity}, занятый объем#{wagon.occupied_capacity}"
      end
    end
  end

  def show_wagon_info
    train = select_train
    if train.wagons.empty?
      puts 'У поезда нет вагонов'
      show_menu
    else
      wagon_info(train)
    end
  end

  def select_wagon
    train = select_train
    if train.wagons.empty?
      puts 'У поезда нет вагонов'
      show_menu
    else
      train.each_wagon { |wagon| puts "Вагон №#{wagon.number}" }
      printf 'Введи номер вагона:'
      number = user_input
      train.wagons.detect { |wagon| wagon.number == number }
    end
  end

  def occupy_wagon_capacity
    wagon = select_wagon
    if wagon.is_a?(PassengerWagon)
      wagon.occupy_capacity
      puts 'Пассажир добавлен'
    elsif wagon.is_a?(CargoWagon)
      printf 'Введи объем груза:'
      amount = user_input
      wagon.occupy_capacity(amount)
      puts 'Груз добавлен'
    end
  end

  def show_routes(routes)
    routes.each_with_index do |route, index|
      printf "#{index}. "
      route.show_route
    end
  end

  def select_route
    routes = Route.all_routes
    if routes.empty?
      puts 'Необходимо создать маршрут'
      show_menu
    else
      show_routes(routes)
      printf 'Выбери маршрут: '
      Route.all_routes[user_input]
    end
  end

  def select_station
    stations = Station.all_stations
    if stations.empty?
      puts 'Необходимо создать станцию'
      show_menu
    else
      stations.each_with_index { |station, i| puts "#{i}. #{station.name}" }
      printf 'Выбери станцию: '
      index = user_input
      stations[index]
    end
  end

  def add_train_wagon
    train = select_train
    if train.is_a?(CargoTrain)
      printf 'Введи максимальный объем:'
      train.wagon_add(CargoWagon.new(user_input))
    elsif train.is_a?(PassengerTrain)
      printf 'Введи кол-во мест:'
      train.wagon_add(PassengerWagon.new(user_input))
    end
  end

  def remove_train_wagon
    train = select_train
    if !train.wagons.empty?
      train.wagon_remove
      puts 'Вагон удален'
    else
      puts 'У поезда нет вагонов'
    end
  end

  def move_train_menu
    {
      1 => 'Вперед',
      2 => 'Назад'
    }
  end

  def move_train
    train = select_train
    if train.route
      case user_choice(move_train_menu)
      when 1 then train.goto_next_station
      when 2 then train.goto_previous_station
      end
      puts "Поезд перемещен на станцию #{train.current_station.name}"
    else
      puts 'Установите маршрут поезду'
    end
  end

  def show_station_info
    station = select_station
    if station.trains.empty?
      puts 'На станции в данный момент нет поездов'
    else
      station.each_train do |train|
        type = train.is_a?(PassengerTrain) ? 'Пассажирский' : 'Грузовой'
        puts "Поезд №#{train.number}, #{type}, \
          количество вагонов #{train.wagons.length}"
      end
    end
  end
end

app = Application.new
#app.show_menu
