# pops the top item of the +:code+ stack and the +:name+ stack;
# if the name string is not a bound variable (as opposed to a local name),
# it binds the name to a new ValuePoint the +:code+ value.
#
# *needs:* 1 +:code+, 1 +:name+
#
# *pushes:* nothing
#

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
