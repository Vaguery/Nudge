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
