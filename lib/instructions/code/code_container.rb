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
