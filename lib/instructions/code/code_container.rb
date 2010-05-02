# pops the top 2 items from the +:code+ stack;
# pushes a new +:code+ item containing a block, which is a copy of the first block in the first argument
# which contains as a child an exact copy of the second argument
#
# note: order matters, and the top stack item is the second argument, the second stack item is the first
#
# For example:
#   first_argument , second_argument -> code_container result
#   [a, b] , z -> []
#   [a,b] , a -> [a,b]
#   [[a,b],c] , a -> [a,b]
#   [a,[b,[c,d]]] , b -> [b,[c,d]]
#   [a,b] , [a,b] -> [a,b]
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:code+
#

class CodeContainerInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  
  def setup
    @searching_in_this = @context.pop_value(:code)
    @searching_for_this = @context.pop_value(:code)
  end
  
  def derive
    needle = NudgeProgram.new(@searching_for_this).linked_code.blueprint
    haystack_program = NudgeProgram.new(@searching_in_this)
    haystack = haystack_program.linked_code
    
    if needle == haystack.blueprint
      result_value = "block {}"
    else
      where = haystack.find_index {|point| point.blueprint == needle}
      result_value = where.nil? ? "block {}" : haystack_program[where].blueprint
    end
    @result = ValuePoint.new("code", result_value)
  end
  
  def cleanup
    pushes :code, @result
  end
end
