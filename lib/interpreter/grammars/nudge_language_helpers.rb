module BlockNode
  def contents
    return innards.text_value
  end
end

module InstructionNode
  def instruction_name
    return opcode.text_value
  end
end

module ChannelNode
  def channel_name
    return chan_name.text_value
  end
end

module LiteralNode
  def stack_name
    return where.text_value
  end
  
  def value
    uncorrected = what.text_value
    case
    when stack_name == "int"
      corrected = uncorrected.to_i
    when stack_name == "bool"
      if uncorrected == "false"
        corrected = false
      else
        corrected = true
      end
    end
    return corrected
  end
end