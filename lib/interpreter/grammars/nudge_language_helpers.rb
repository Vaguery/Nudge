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
  # extending SyntaxNodes found by nudge_language.treetop grammar
  # 'literal int, 6'
  # 'literal float, -4.3'
  # 'literal robot, <WTF>'
  
  # single word string naming stack where 'what' will be pushed
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
end