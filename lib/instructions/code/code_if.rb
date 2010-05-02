# pops the top 2 items of the +:code+ stack, and one +:bool+;
# returns the top +:code+ item if the +:bool+ is +false+, the second one if +true+
#
# *needs:* 2 +:code+, 1 +:bool+
#
# *pushes:* 1 +:code+
#

class CodeIfInstruction < Instruction
  
  def preconditions?
    needs :code, 2
    needs :bool, 1
  end
  
  def setup
    @stay = @context.pop_value(:bool)
    @ifFalse = @context.pop_value(:code)
    @ifTrue = @context.pop_value(:code)
  end
  
  def derive
    which = @stay ? @ifTrue : @ifFalse
    @result = NudgeProgram.new(which).linked_code
  end
  
  def cleanup
    pushes :exec, @result
  end
end