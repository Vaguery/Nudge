


class IntPointParser
  def build(string_value)
    return string_value.to_i
  end
end


class BoolPointParser
  def build(string_value)
    return string_value.downcase == "true"
  end
end


class FloatPointParser
  def build(string_value)
    return string_value.to_f
  end
end
