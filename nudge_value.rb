class NudgeValue
  TYPES = {:bool => nil, :code => nil, :float => nil, :int => nil, :name => nil, :proportion => nil}
  
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
  
  class ::String
    alias to_int to_i
    alias to_float to_f
    alias to_name intern
    alias to_code to_s
    alias to_proportion to_f
    
    def to_bool
      self == "true"
    end
  end
end
