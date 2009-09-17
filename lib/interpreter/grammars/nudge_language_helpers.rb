module BlockNode
  def to_code
    newBlob = Code.new(text_value)
    return newBlob
  end
end

module InstructionNode
  def instruction_name
    return opcode.text_value
  end
  
  def to_code
    newBlob = Code.new(text_value)
    newBlob.contents = [ Instruction.new(opcode.text_value) ]
    return newBlob
  end
end

module ChannelNode
  def channel_name
    return chan_name.text_value
  end
  
  def to_code
    newBlob = Code.new(text_value)
    newBlob.contents = [ Channel.new(channel_name) ]
    return newBlob
  end
  
end

module LiteralNode
  # extending SyntaxNode instances created by nudge_language.treetop grammar matcher
  # will recognize:
  #   'literal int, 6'
  #   'literal float, -4.3'
  #   'literal robot, some random crap like <0xFFFFFF>'
  
  # stack_name is an alpha+underscored string naming stack where 'what' will be pushed
  # ex: 'int', 'float', 'robot' (see above)
  def stack_name
    return where.text_value
  end
  
  # assigned_value.text_value is the right hand side of the literal line, as a string
  # ex: '6', '-4.3', '<WTF>' as a string
  def value
    # this depends on existence of class {stack_name}Literal with #build that returns
    "#{stack_name.capitalize}Literal".constantize.new.build(assigned_value.text_value)
  end
  
  def to_code
    newBlob = Code.new(text_value)
    newBlob.contents = [ Literal.new(stack_name,value) ]
    return newBlob
  end
  
end

module ERCNode
  # just like a LiteralNode for our purposes
  #   'erc int, 6'
  # (in future versions, value parameter may become optional and sample upon execution)
  #   'erc int'
  def stack_name
    return where.text_value
  end
  
  def value
    # this depends on existence of class {stack_name}Erc with #build that returns the value
    # (in future versions, #build will also resample if nil)
    "#{stack_name.capitalize}ERC".constantize.new.build(assigned_value.text_value)
  end
  
  def to_code
    newBlob = Code.new(text_value)
    newBlob.contents = [ Erc.new(stack_name,value) ]
    return newBlob
  end
  
end