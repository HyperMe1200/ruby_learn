print('Введи свое имя: ')
name = String(gets.chomp)
print('Введи свой вес: ')
heigth = Integer(gets.chomp)

ideal_weigth = heigth - 110

if ideal_weigth < 0
  message = 'Ваш вес уже оптимальный'
else
  message = "#{name}, ваш оптимальный вес = " + ideal_weigth.to_s + 'кг'
end

puts message
