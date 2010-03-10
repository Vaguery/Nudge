class CodeNoopInstruction < Instruction
  def preconditions?
    true
  end

  def setup
  end

  def derive
  end

  def cleanup
  end
end



class CodeNullQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @arg1 = NudgeProgram.new(arg_listing).listing
  end
  def derive
    @result = ValuePoint.new("bool", @arg1 == "block {}")
  end
  def cleanup
    pushes :bool, @result
  end
end



class CodeAtomQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @arg1 = NudgeProgram.new(arg_listing)
  end
  def derive
    atomQ = @arg1.parses? && @arg1.points == 1
    @result = ValuePoint.new("bool", atomQ)
  end
  def cleanup
    pushes :bool, @result
  end
end



class CodeLengthInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @parsed = NudgeProgram.new(arg_listing)
  end
  def derive
    if @parsed.linked_code kind_of?(CodeblockPoint)
      len = @parsed[1].contents.length
    elsif @parsed.parses? == false
      len = ValuePoint.new("int", 0)
    else
      len = 1
    end
    ValuePoint.new("int", len)
  end
  def cleanup
    pushes :int, @result
  end
end



class CodePointsInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.stacks[:code].pop.value
    @parsed = NudgeProgram.new(arg_listing)
  end
  def derive
    @result = ValuePoint.new("int",@parsed.points)
  end
  def cleanup
    pushes :int, @result
  end
end



class CodeQuoteInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    next_point = @context.stacks[:exec].pop
    top,bottom = next_point.listing_parts
    @parsed = NudgeProgram.new("#{top.strip}\n#{bottom.strip}")
  end
  def derive
    @result = ValuePoint.new("code", @parsed.listing)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeNameLookupInstruction < Instruction
  def preconditions?
    needs :name, 1
  end
  def setup
    @the_reference = @context.stacks[:name].pop.value
  end
  def derive
    bound_value = @context.variables[@the_reference] || @context.names[@the_reference] || nil
    if bound_value != nil
      @result = ValuePoint.new("code", bound_value.listing)
    else
      @result = ValuePoint.new("code", "")
    end
  end
  def cleanup
    pushes :code, @result
  end
  
end



class CodeDefineInstruction < Instruction
  def preconditions?
    needs :code, 1
    needs :name, 1
  end
  def setup
    @ref = @context.stacks[:name].pop.name
    @code = @context.stacks[:code].pop.value
  end
  def derive
    if @context.variables.keys.include?(@ref)
      raise "cannot change the value of a variable"
    else
      new_value = NudgeProgram.new(@code).linked_code
      @context.names[@ref] = new_value
    end
  end
  def cleanup
  end
end



class CodeNthInstruction < Instruction
  def preconditions?
    needs :int, 1
    needs :code, 1
  end
  def setup
    @arg1 = @context.stacks[:int].pop.value
    @arg2 = @context.stacks[:code].pop.value
  end
  def derive
    tree = NudgeProgram.new(@arg2)
    if tree.linked_code.kind_of?(CodeblockPoint)
      pts = tree[1].contents.length
      val = tree[1].contents[@arg1 % pts]
    else
      val = tree
    end
    @result = ValuePoint.new("code", val.listing)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeNthPointInstruction < Instruction
  def preconditions?
    needs :int, 1
    needs :code, 1
  end
  def setup
    @arg1 = @context.stacks[:int].pop.value
    @arg2 = @context.stacks[:code].pop.value
  end
  def derive
    tree = NudgeProgram.new(@arg2)
    tree_size = tree.points
    which = (@arg1-1) % tree_size + 1
    pt = tree[which]
    @result = ValuePoint.new("code", pt.listing)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeCdrInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg = @context.stacks[:code].pop.value
  end
  def derive
    tree = NudgeProgram.new(@arg)
    if tree.linked_code.kind_of?(CodeblockPoint) && (tree.points > 2)
      new_tree = tree.delete_point(2)
    else
      new_tree = CodeblockPoint.new([])
    end
    @result = ValuePoint.new("code", new_tree.listing)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeCarInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg = @context.stacks[:code].pop.value
  end
  def derive
    tree = NudgeProgram.new(@arg)
    if tree.linked_code.kind_of?(CodeblockPoint) && (tree.points > 2)
      new_tree = tree[1].contents[0]
    else
      new_tree = tree
    end
    @result = ValuePoint.new("code", new_tree.listing)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeExecuteInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg = @context.stacks[:code].pop.value
  end
  def derive
    that_becomes = NudgeProgram.new(@arg)
    if that_becomes.parses?
      @result = NudgeProgram.new(@arg).linked_code
    else
      @result = CodeblockPoint.new([])
    end
  end
  def cleanup
    pushes :exec, @result
  end
end



class CodeInstructionsInstruction < Instruction
  def preconditions?
    true
  end
  def setup
  end
  def derive
    all_instructions = @context.instructions
    list_as_block = all_instructions.inject("block {") {|b,i| b + " do #{i.to_nudgecode}"} + "}"
    @result = ValuePoint.new("code", list_as_block)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeMemberQInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.stacks[:code].pop.value
    @arg1 = @context.stacks[:code].pop.value
  end
  def derive
    looking_for_this = NudgeProgram.new(@arg1)
    tree = NudgeProgram.new(@arg2)
    if tree.parses? && looking_for_this.parses?
      if tree.linked_code.kind_of?(CodeblockPoint)
        found = tree[1].contents.any? {|branch| branch.listing == looking_for_this.listing}
      else
        found = (tree.listing == looking_for_this.listing)
      end
    else
      found = false
    end
    @result = ValuePoint.new("bool", found)
  end
  def cleanup
    pushes :bool, @result
  end
end



class CodeContainsQInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.stacks[:code].pop.value
    @arg1 = @context.stacks[:code].pop.value
  end
  def derive
    looking_for_this = NudgeProgram.new(@arg1)
    tree = NudgeProgram.new(@arg2)
    if tree.parses? && looking_for_this.parses?
      found = tree.linked_code.any? {|point| point.listing == looking_for_this.listing}
    else
      found = false
    end
    @result = ValuePoint.new("bool", found)
  end
  def cleanup
    pushes :bool, @result
  end
end