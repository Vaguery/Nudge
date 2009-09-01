class LiteralMismatchError < TypeError
end

class IntLiteral
  def build(string_value)
    return string_value.to_i
  end
end

class IntERC
  def build(string_value)
    return string_value.to_i
  end
end

class BoolLiteral
  def build(string_value)
    return string_value.downcase == "true"
  end
end

class BoolERC
  def build(string_value)
    return string_value.downcase == "true"
  end
end


class FloatLiteral
  def build(string_value)
    return string_value.to_f
  end
end

class FloatERC
  def build(string_value)
    return string_value.to_f
  end
end