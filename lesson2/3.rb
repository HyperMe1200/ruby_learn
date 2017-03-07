# не понял, необходимо вычислить для каждого числа от 0 до 100
# или вычислять пока получаемое значение < 100
# поэтому оба варианта

def fibonacci1(count)
  fib = []
  fib[0] = 0
  fib[1] = 1
  (count + 1).times {|n| fib[n] = fib[n-1] + fib[n-2] if fib[n].nil?}

  return fib

end

def fibonacci2(max_value)
  fib = []
  fib[0] = 0
  fib[1] = 1
  n = 0
  loop do
    n += 1
    fib[n] = fib[n-1] + fib[n-2] if fib[n].nil?
    break if fib[n] > max_value - fib[n - 1]
  end

  return fib

end

fib1 = fibonacci1(100)
fib2 = fibonacci2(100)