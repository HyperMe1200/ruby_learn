# не понял, необходимо вычислить для каждого числа от 0 до 100
# или вычислять пока получаемое значение < 100
# поэтому оба варианта

def fibonacci1(count)
  fib = [0, 1]
  fib << fib[-1] + fib[-2] while fib.length < count
  fib
end

def fibonacci2(max_value)
  fib = [0, 1]
  fib << fib[-1] + fib[-2] while fib[-1] + fib[-2] < max_value
  fib
end

fib1 = fibonacci1(100)
fib2 = fibonacci2(100)
puts fib1.count