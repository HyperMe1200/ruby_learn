module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history = "@#{name}_history".to_sym
      history_values = []
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        instance_variable_set(var_history, history_values << value)
      end
      define_method("#{name}_history".to_sym) { instance_variable_get(var_history) }
    end
  end

  def strong_attr_acessor(name, type)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
    raise 'Неверный тип данных' unless value.is_a?(type)
    instance_variable_set(var_name, value)
    end
  end
end
