class NudgeType
  def self.inherited (klass)
    String.send(:define_method, "to_#{klass.name.demodulize.underscore}") do
      klass.from_s(self)
    end
  end
end

class String
  alias to_int to_i
  alias to_float to_f
  alias to_name intern
  alias to_code to_s
  alias to_proportion to_f
  
  def to_bool
    self == "true"
  end
end
