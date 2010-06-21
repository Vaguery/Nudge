class NudgeType
  def self.inherited (klass)
    type = klass.name.
      gsub(/^.*::/, '').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      downcase
    
    String.send(:define_method, "to_#{type}") do
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
