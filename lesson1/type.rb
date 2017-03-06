def equilateral_triangle?(a, b, c)
  a == b && a == c
end

def isosceles_triangle?(a, b, c)
  a == b || a == c || b == c
end

def right_triangle?(a, b, c)
  sides = [a, b, c].sort!
  sides[2] ** 2 == sides[1] ** 2 + sides[0] ** 2
end

print 'Введи сторону треугольника а: '
a = gets.to_f
print 'Введи сторону треугольника b: '
b = gets.to_f
print 'Введи сторону треугольника c: '
c = gets.to_f

puts 'Равнобедренный треугольник' if isosceles_triangle?(a, b, c)
puts 'Равносторонний треугольник' if equilateral_triangle?(a, b, c)
if right_triangle?(a, b, c)
  puts 'Прямоугольный треугольник'
else
  puts 'Треугольник не прямоугольный'
end

