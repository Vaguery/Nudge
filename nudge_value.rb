# encoding: UTF-8
class NudgeValue
  TYPES = {}
  
  def NudgeValue.inherited (klass)
    value_type = klass.name.
      gsub(/^.*::/, '').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      downcase.intern
    
    TYPES[value_type] = klass
    
    def klass.random
      ""
    end
    
    String.send(:define_method, "to_#{value_type}") do
      klass.from_s(self)
    end
  end
  
  String.send(:alias_method, :to_code, :to_s)
  String.send(:alias_method, :to_float, :to_f)
  String.send(:alias_method, :to_int, :to_i)
  String.send(:alias_method, :to_name, :intern)
  String.send(:alias_method, :to_proportion, :to_f)
  String.send(:define_method, :to_bool) { self == "true" }
end
