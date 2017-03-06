def equilateral_triangle?(a,b,c)
  a == b && a == c
end

def isosceles_triangle?(a,b,c)
  a == b || a == c || b == c
end

def right_triangle?(a,b,c)
  (a**2 == b**2 + c**2) || (b**2 == a**2 + c**2) || (c**2 == a**2 + b**2)
end

print 'Введи сторону треугольника а: '
a = gets.to_i
print 'Введи сторону треугольника b: '
b = gets.to_i
print 'Введи сторону треугольника c: '
c = gets.to_i

puts 'Равнобедренный треугольник' if isosceles_triangle?(a,b,c)
puts 'Равносторонний треугольник' if equilateral_triangle?(a,b,c)
puts 'Прямоугольный треугольник' if right_triangle?(a,b,c)

