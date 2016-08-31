require 'factory_girl'
require 'thread'

# This module adds helper methods to FactoryGirl to memoize instances created by factories.
module FactoryGirl::AnyInstance
  
  # Create or return an instance of the specified factory. If this method has been called
  # previously with the same factory name, then the previously created instance will be returned.
  # Otherwise a new instance will be created using all the default factory settings and stored
  # until `clear_instances` is called.
  def any(factory_name)
    factory_name = factory_name.to_sym
    instance = any_instances[factory_name]
    unless instance
      instance = FactoryGirl.create(factory_name)
      @any_instance_lock.synchronize do
        @any_instances[factory_name] = instance
      end
    end
    instance
  end
  
  # Clear all the memoized instances. Instances are kept in a global namespace and
  # must be cleared between test runs.
  def clear_instances
    if defined?(@any_instances) && @any_instances
      @any_instances = {}
    end
  end
  
  private
  
  def any_instances
    @any_instance_lock ||= Mutex.new
    @any_instances ||= {}
  end
  
end

FactoryGirl.extend(FactoryGirl::AnyInstance)
FactoryGirl::Syntax::Methods.module_exec do
  define_method(:any){|factory_name| FactoryGirl.any(factory_name)}
  define_method(:clear_instances){ FactoryGirl.clear_instances}
end
