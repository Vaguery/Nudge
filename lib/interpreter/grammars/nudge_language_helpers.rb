module BlockNode
  def to_points
    newBlob = CodeBlock.new(text_value)
    newBlob.contents = innards.elements.collect {|item| item.to_points}
    newBlob.listing = newBlob.tidy
    return newBlob
  end
end

module InstructionNode
  def instruction_name
    return opcode.text_value
  end
  
  def to_points
    newBlob = InstructionPoint.new(opcode.text_value)
    return newBlob
  end
end

module ChannelNode
  def channel_name
    return chan_name.text_value
  end
  
  def to_points
    newBlob = Channel.new(channel_name)
    return newBlob
  end
  
end

module LiteralNode
  def stack_name
    return where.text_value
  end
  
  def value
    # this depends on existence of class {stack_name}Literal with #build that returns
    "#{stack_name.capitalize}Type".constantize.from_s(assigned_value.text_value)
  end
  
  def to_points
    newBlob = LiteralPoint.new(stack_name,value)
    return newBlob
  end
end

module ERCNode
  def stack_name
    return where.text_value
  end
  
  def value
    # this depends on existence of class {stack_name}Erc with #build that returns the value
    "#{stack_name.capitalize}Type".constantize.from_s(assigned_value.text_value)
  end
  
  def to_points
    newBlob = Erc.new(stack_name,value)
    return newBlob
  end
end