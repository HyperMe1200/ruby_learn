module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    attr_accessor :instances

    def set_instances
      self.instances.nil? ? self.instances = 1 : self.instances += 1
    end
  end

  module InstanceMethods

    protected
    def register_instance
      self.class.set_instances
    end
  end
end
