module BlockNode
  def to_points
    newBlob = CodeBlock.new(text_value)
    newBlob.contents = innards.elements.collect {|item| item.to_points}
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
  # stack_name is an alpha+underscored string naming stack where 'what' will be pushed
  # ex: 'int', 'float', 'robot' (see above)
  def stack_name
    return where.text_value
  end
  
  # assigned_value.text_value is the right hand side of the literal line, as a string
  # ex: '6', '-4.3', '<WTF>' as a string
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
  # just like a LiteralNode for our purposes
  #   'sample int, 6'
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