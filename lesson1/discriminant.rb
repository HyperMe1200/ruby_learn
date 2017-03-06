print 'Введи коэффициент a: '
a = gets.to_f
print 'Введи коэффициент b: '
b = gets.to_f
print 'Введи коэффициент c: '
c = gets.to_f

d = b**2 - 4 * a * c
puts 'Дискриминант = ' + d.to_s

if d < 0
  puts 'Корней нет'
elsif d == 0
  x = -b / 2 * a
  puts 'Уравнение имеет один корень x = ' + x.to_s
else
  x1 = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)
  puts "Уравнение имеет два корня: х1 = #{x1} и х2 = #{x2}"
end