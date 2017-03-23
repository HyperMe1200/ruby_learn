module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, validation = nil, argument = nil)
      @validations ||= {}
      @validations[name] ||= {}
      @validations[name] = {validation: validation, argument: argument}
    end
  end

  module InstanceMethods
    def validate!
      validations = self.class.validations
      validations.each do |name, validation|
        value = instance_variable_get("@#{name}".to_sym)
        send(validation[:validation], value, validation[:argument])
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def presence(variable, noneed)
      raise 'Переменная не задана' if variable.nil? || variable.empty?
    end

    def type(variable, type)
      raise 'Неправильный тип переменной' unless variable.is_a?(type)
    end

    def format(variable, regex)
      raise 'Неправильный формат переменной' unless variable =~ regex
    end
  end
end

