#encoding: utf-8
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
    arg_listing = @context.pop_value(:code)
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
    arg_listing = @context.pop_value(:code)
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
    arg_listing = @context.pop(:code).listing
    @arg1 = NudgeProgram.new(arg_listing)
  end
  def derive
    if @arg1.linked_code.kind_of?(CodeblockPoint)
      len = @arg1[1].contents.length
    elsif @arg1.parses? == false
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
    arg_listing = @context.pop_value(:code)
    @parsed = NudgeProgram.new(arg_listing)
  end
  def derive
    @result = ValuePoint.new("int",@parsed.points)
  end
  def cleanup
    pushes :int, @result
  end
end



class CodeBackbonePointsInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.pop_value(:code)
    @parsed = NudgeProgram.new(arg_listing)
  end
  def derive
    if @parsed.parses?
      pts = @parsed.linked_code.kind_of?(CodeblockPoint) ? @parsed[1].contents.length : 0
    else
      pts = 0
    end
    @result = ValuePoint.new("int",pts)
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
    @arg = @context.pop(:exec).listing
  end
  def derive
    @result = ValuePoint.new("code", @arg)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeNameLookupInstruction < Instruction  # was Push3 CODE.DEFINITION
  def preconditions?
    needs :name, 1
  end
  def setup
    @the_reference = @context.pop_value(:name)
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
    @ref = @context.pop(:name).name
    @code = @context.pop_value(:code)
  end
  def derive
    if @context.variables.keys.include?(@ref)
      raise InstructionMethodError, "#{self.class.to_nudgecode} cannot change the value of a variable"
    else
      new_value = NudgeProgram.new(@code).linked_code
      raise InstructionMethodError, "#{self.class.to_nudgecode} cannot parse '#{@code}'" if new_value.is_a?(NilPoint)
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
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:code)
  end
  def derive
    tree = NudgeProgram.new(@arg2)
    if tree.linked_code.kind_of?(CodeblockPoint)
      pts = tree[1].contents.length
      raise InstructionMethodError, "#{self.class} can't work on empty blocks" if pts < 1
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



class CodeNthPointInstruction < Instruction # was CODE.EXTRACT in Push3
  def preconditions?
    needs :int, 1
    needs :code, 1
  end
  def setup
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:code)
  end
  def derive
    tree = NudgeProgram.new(@arg2)
    tree_size = tree.points
    raise InstructionMethodError, "#{self.class} divied by zero" if tree_size < 1
    which = (@arg1-1) % tree_size + 1
    pt = tree[which]
    @result = ValuePoint.new("code", pt.listing)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeReplaceNthPointInstruction < Instruction # was CODE.INSERT in Push3
  def preconditions?
    needs :int, 1
    needs :code, 2
  end
  def setup
    @where = @context.pop_value(:int)
    @accept = @context.pop_value(:code)
    @insert = @context.pop_value(:code)
  end
  def derive
    acceptor = NudgeProgram.new(@accept)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless acceptor.parses?
    insertion = NudgeProgram.new(@insert)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless insertion.parses?
    scale = acceptor.points
    which_pt = if @where < 1 || @where > scale
      (@where % acceptor.points) + 1
    else
      @where
    end
    new_tree = acceptor.replace_point(which_pt, insertion.linked_code).listing
    @result = ValuePoint.new("code", new_tree)
  end
  def cleanup
    pushes :code, @result
  end
end


# ORIGINAL PUSH3 DESCRIPTION: Pushes the result of substituting the third item on the code stack for the second item in the first item. As of this writing this is implemented only in the Lisp implementation, within which it relies on the Lisp "subst" function. As such, there are several problematic possibilities; for example "dotted-lists" can result in certain cases with empty-list arguments. If any of these problematic possibilities occurs the stack is left unchanged.

# Here, we will pop three :code items, find all occurrences of the appropriate point in the changed codeblock, and then replace them in last-to-first order (so the point counts discovered initially don't change during substitution)

class CodeGsubInstruction < Instruction # was CODE.SUBST in Push3
  def preconditions?
    needs :code, 3
  end
  def setup
    @host_tree = @context.pop_value(:code)
    @old_subtree = @context.pop_value(:code)
    @new_subtree = @context.pop_value(:code)
  end
  def derive
    new_tree = NudgeProgram.new(@new_subtree)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless new_tree.parses?
    old_tree = NudgeProgram.new(@old_subtree)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless old_tree.parses?
    host = NudgeProgram.new(@host_tree)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless host.parses?
    
    found_at = [] # need to iterate through the tree the slow way to capture the indices (I think)
    host.linked_code.each_with_index do |point, index|
      found_at << (index+1) if point.listing == old_tree.listing
    end
    found_at.reverse.each {|index| host = host.replace_point(index, new_tree.linked_code)}
    @result = ValuePoint.new("code", host.listing)
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
    @arg = @context.pop_value(:code)
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



class CodeNthCdrInstruction < Instruction
  def preconditions?
    needs :int, 1
    needs :code, 1
  end
  def setup
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:code)
  end
  def derive
    tree = NudgeProgram.new(@arg2)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot parse the argument" unless tree.parses?
    backbone = tree.linked_code
    if backbone.kind_of?(CodeblockPoint)
      b_len = backbone.contents.length
      if b_len > 0
        new_tree = CodeblockPoint.new(backbone.contents.slice(@arg1 % b_len, b_len))
      else
        new_tree = CodeblockPoint.new([])
      end
    else
      new_tree = @arg1 > 0 ? CodeblockPoint.new([tree.linked_code]) : CodeblockPoint.new([])
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
    @arg = @context.pop_value(:code)
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


class CodeListInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    listed = []
    listed << NudgeProgram.new(@arg1).linked_code unless @arg1 == ""
    listed << NudgeProgram.new(@arg2).linked_code unless @arg2 == ""
    combined = CodeblockPoint.new(listed).listing
    @result = ValuePoint.new("code", combined)
  end
  def cleanup
    pushes :code, @result
  end
end



class CodeConcatenateInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    t1 = NudgeProgram.new(@arg1)
    t2 = NudgeProgram.new(@arg2)
    if t1.parses? && t2.parses?
      if t1.linked_code.kind_of?(CodeblockPoint)
        if t2.linked_code.kind_of?(CodeblockPoint)
          new_tree = t1[1].contents + t2[1].contents
        else
          new_tree = t1[1].contents << t2.linked_code
        end
      else
        new_tree = [t1.linked_code, t2.linked_code]
      end
      listed = CodeblockPoint.new(new_tree).listing
      @result = ValuePoint.new("code", listed)
    else
      @result = ValuePoint.new("code", "block {}")
    end
  end
  def cleanup
    pushes :code, @result
  end
end


# This is a tricky one to translate from Push, which assumes a very Lisp-like list structure. Here we'll simply build a new block with the consed item first, and the original code second.

class CodeConsInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    t1 = NudgeProgram.new(@arg1)
    t2 = NudgeProgram.new(@arg2)
    if t1.parses? && t2.parses?
      consed_tree = t2.insert_point_before(1,t1.linked_code)
    else
      raise InstructionMethodError,
        "#{self.class.to_nudgecode} cannot parse the arguments"
    end
    @result = ValuePoint.new("code", consed_tree.listing)
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
    @arg = @context.pop_value(:code)
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




class CodeExecuteThenPopInstruction < Instruction
  def preconditions?
    needs CodePopInstruction
    needs :code, 1
  end
  def setup
    @arg = @context.peek_value(:code) # does not pop the stack initially!
  end
  def derive
    that_becomes = NudgeProgram.new(@arg)
    if that_becomes.parses?
      @result = CodeblockPoint.new([NudgeProgram.new(@arg).linked_code,InstructionPoint.new("code_pop")])
    else
      @result = CodeblockPoint.new([InstructionPoint.new("code_pop")])
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
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
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
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
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


class CodePositionInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    looking_for_this = NudgeProgram.new(@arg1).linked_code
    inside_this = NudgeProgram.new(@arg2).linked_code
    if inside_this && looking_for_this
      index = inside_this.find_index {|point| point.listing == looking_for_this.listing} || -2
    else
      index = -2
    end
    @result = ValuePoint.new("int", index+1)
  end
  def cleanup
    pushes :int, @result
  end
end



# ORIGINAL DESCRIPTION: An iteration instruction that executes the top item on the CODE stack a number of times that depends on the top two integers, while also pushing the loop counter onto the INTEGER stack for possible access during the execution of the body of the loop. The top integer is the "destination index" and the second integer is the "current index." First the code and the integer arguments are saved locally and popped. Then the integers are compared. If the integers are equal then the current index is pushed onto the INTEGER stack and the code (which is the "body" of the loop) is pushed onto the EXEC stack for subsequent execution. If the integers are not equal then the current index will still be pushed onto the INTEGER stack but two items will be pushed onto the EXEC stack -- first a recursive call to CODE.DO*RANGE (with the same code and destination index, but with a current index that has been either incremented or decremented by 1 to be closer to the destination index) and then the body code. Note that the range is inclusive of both endpoints; a call with integer arguments 3 and 5 will cause its body to be executed 3 times, with the loop counter having the values 3, 4, and 5. Note also that one can specify a loop that "counts down" by providing a destination index that is less than the specified current index.

# That description must be flawed; "a recursive call to CODE.DO*RANGE" would not run the same code, but rather run the next piece of code from the :code stack. I'm interpreting it as a typo, and using exec_do_range instead, since that will have the desired outcome without running through all kinds of weird :code items.

class CodeDoRangeInstruction < Instruction
  def preconditions?
    needs ExecDoRangeInstruction
    needs :code, 1
    needs :int, 2
  end
  
  def setup
    @destination = @context.pop(:int)
    @counter = @context.pop(:int)
    @code = @context.pop_value(:code)
  end
  
  def derive
    @codeblock = NudgeProgram.new(@code).linked_code
    @finished = false
    if @counter.value == @destination.value
      @finished = true
    elsif @counter.value < @destination.value
      @new_counter = ValuePoint.new("int", @counter.value + 1)
    else
      @new_counter = ValuePoint.new("int", @counter.value - 1)
    end
    @recursor = CodeblockPoint.new([@new_counter, @destination,
      InstructionPoint.new("exec_do_range"),@codeblock])
  end
  
  def cleanup
    if @finished
      pushes :int, @counter
      pushes :exec, @codeblock
    else
      pushes :int, @counter
      pushes :exec, @recursor
      pushes :exec, @codeblock
    end
  end
end


# Again, the original description of this instruction appears to be confusing "CODE.DO*RANGE" with "EXEC.DO*RANGE"; I've made the adjustment to the code so that the behavior is as described, not the implementation.

class CodeDoCountInstruction < Instruction
  def preconditions?
    needs ExecDoRangeInstruction
    needs :code, 1
    needs :int, 1
  end
  
  def setup
    @destination = @context.pop(:int)
    @code = @context.pop_value(:code)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} needs a positive argument" if @destination.value < 1
  end
  
  def derive
    @codeblock = NudgeProgram.new(@code).linked_code
    @one_less = ValuePoint.new("int",@destination.value-1)
  end
  
  def cleanup
    recursor = CodeblockPoint.new([ValuePoint.new("int",0), @one_less,
      InstructionPoint.new("exec_do_range"),@codeblock])
    pushes :exec, recursor
  end
end


# Again, the original description of this instruction appears to be confusing "CODE.DO*RANGE" with "EXEC.DO*RANGE"; I've made the adjustment to the code so that the behavior is as described, not the implementation.

class CodeDoTimesInstruction < Instruction
  def preconditions?
    needs ExecDoTimesInstruction
    needs :code, 1
    needs :int, 2
  end
  
  def setup
    @destination = @context.pop(:int)
    @counter = @context.pop(:int)
    @code = @context.pop_value(:code)
  end
  
  def derive
    @finished = false
    if @counter.value == @destination.value
      @finished = true
    elsif @counter.value < @destination.value
      @new_counter = ValuePoint.new("int", @counter.value + 1)
    else
      @new_counter = ValuePoint.new("int", @counter.value - 1)
    end
    @codeblock = NudgeProgram.new(@code).linked_code
  end
  
  def cleanup
    if @finished
      pushes :exec, @codeblock
    else
      recursor = CodeblockPoint.new([@new_counter, @destination,
        InstructionPoint.new("exec_do_times"),@codeblock])
      pushes :exec, recursor
      pushes :exec, @codeblock
    end
  end
end



class CodeParsesQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg1 = @context.pop_value(:code)
  end
  def derive
    answer = NudgeProgram.new(@arg1).parses? ? true : false
    @result = ValuePoint.new("bool", answer)
  end
  def cleanup
    pushes :bool, @result
  end
end



# ORIGINAL DESCRIPTION in Push3:
# Pushes a measure of the discrepancy between the top two CODE stack items onto the INTEGER stack. This will be zero if the top two items are equivalent, and will be higher the 'more different' the items are from one another. The calculation is as follows:
# 1. Construct a list of all of the unique items in both of the lists (where uniqueness is determined by equalp). Sub-lists and atoms all count as items.
# 2. Initialize the result to zero.
# 3. For each unique item increment the result by the difference between the number of occurrences of the item in the two pieces of code.
# 4. Push the result.


class CodeDiscrepancyInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
     # collect string listings of every point
    parts_of_1 = NudgeProgram.new(@arg1).linked_code.collect {|pt| pt.listing}
    parts_of_2 = NudgeProgram.new(@arg2).linked_code.collect {|pt| pt.listing}
    unique_parts = (parts_of_1.uniq + parts_of_2.uniq).reject {|i| i == ""}
    summed_differences = unique_parts.inject(0) {|sum, uniq_string| sum +
      (parts_of_2.count(uniq_string) - parts_of_1.count(uniq_string)).abs}
    @result = ValuePoint.new("int", summed_differences)
  end
  def cleanup
    pushes :int, @result
  end
end



# Pushes the "container" of the second CODE stack item within the first CODE stack item onto the CODE stack. If second item contains the first anywhere (i.e. in any nested list) then the container is the smallest sub-list that contains but is not equal to the first instance. For example, if the top piece of code is "( B ( C ( A ) ) ( D ( A ) ) )" and the second piece of code is "( A )" then this pushes ( C ( A ) ). Pushes an empty list if there is no such container


class CodeContainerInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @searching_in_this = @context.pop_value(:code)
    @searching_for_this = @context.pop_value(:code)
  end
  def derive
    needle = NudgeProgram.new(@searching_for_this).linked_code.listing
    haystack_program = NudgeProgram.new(@searching_in_this)
    haystack = haystack_program.linked_code
    
    if needle == haystack.listing
      result_value = "block {}"
    else
      where = haystack.find_index {|point| point.listing == needle}
      result_value = where.nil? ? "block {}" : haystack_program[where].listing
    end
    @result = ValuePoint.new("code", result_value)
  end
  def cleanup
    pushes :code, @result
  end
end
