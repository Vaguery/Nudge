# Pops two values from the +:int+ stack ("destination" and "counter"), and one item from the +:code+ stack.
# The net effect of the instruction (unless interfered with by another operation)
# is to evaluate the +:code+ item once for every integer in the range (inclusive), and
# at the same time push the counter integer onto the +:int+ stack.
#
# note: rather than duplicating the functionality of the ExecDoRangeInstruction, that is used as a macro here
#
# note: the first integer popped is the "destination", the second one the "counter"
# (regardless of their values or signs)
#
# note: unlike the CodeDoTimes instruction, the counter is pushed
#
# <b>If the counter and destination have the same value</b>, then a new +:int+ is pushed with that value,
# and the +:code+ item is pushed onto the +:exec+ stack.
#
# <b>If the counter and destination have different values</b>, then a "new_counter" value
# is calculated that is *one step closer to the destination*.
#
# A ValuePoint containing the following "macro" is created:
#   block {
#     value «int»
#     value «int»
#     do exec_do_range
#     popped item
#   }
#   «int» new_counter
#   «int» destination
# where +popped_item+ is the code from the +:code+ stack, and +new_counter+ and +destination+ are the numeric values that were derived above.
#
# Finally,
# 1. a new ValuePoint whose value is +new_counter+ is pushed to the +:int+ stack;
# 2. the macro is pushed onto the +:exec+ stack
# 3. another copy of the +popped_item+ is pushed onto the +:exec+ stack (on top of the macro)
#
# The consequence is that the original +:code+ item will be executed (at least once),
# the counter will be pushed onto the +:int+ stack,
# the macro will be encountered, and this cycle will repeat via the ExecDoRangeInstruction.
#
# note: if the +popped_item+ itself manipulates the +:exec+ stack, "complicated behavior" may arise 
#
# *needs:* 2 +:int+ items, 1 +:code+ item
#
# *pushes:* well, it's complicated...
#

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
