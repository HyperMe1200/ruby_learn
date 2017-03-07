cart = {}

loop do
  puts 'Введи название товара'
  product = gets.chomp
  break if product == 'стоп'

  puts 'Введи цену товара'
  price = gets.to_f

  puts 'Введи кол-во товара'
  quantity = gets.to_f

  cart[product] = { price: price, quantity: quantity }
end

total_sum = 0

cart.each do |product, value|
  sum = value[:price] * value[:quantity]
  total_sum += sum
  puts "Продукт: #{product} Цена: #{value[:price]} Количество: #{value[:quantity]} Сумма: #{sum}"
end

puts "Итоговая цена: #{total_sum}"
