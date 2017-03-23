# Helper module
module Helper
  def user_input(type = 'int')
    type == 'str' ? gets.chomp : gets.to_i
  end

  def print_prompt
    printf 'Выбери пункт меню:'
  end

  def print_wrong_input
    puts 'Введен некорректный пункт меню'
  end

  def user_choice(menu, input_type = 'int')
    menu.each { |key, value| puts "#{key}. #{value}" }
    print_prompt
    key = input_type == 'int' ? user_input : user_input('str')
    return print_wrong_input unless menu.key?(key)
    key
  end
end
