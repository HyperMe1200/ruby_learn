# InstanceCounter module
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # ClassMethods module
  module ClassMethods
    def instances
      @instances ||= 0
    end

    def instances=(count)
      @instances = count
    end
  end

  # InstanceMethods module
  module InstanceMethods
    protected

    def register_instance
      self.class.instances += 1
    end
  end
end
