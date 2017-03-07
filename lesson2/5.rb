puts 'Введи год'
year = gets.to_i

puts 'Введи месяц'
month = gets.to_i

puts 'Введи день'
day = gets.to_i

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

months[1] = 29 if ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?

puts "#{months[0..month - 1].inject(:+) - (months[month - 1] - day)}й день #{year} года"
