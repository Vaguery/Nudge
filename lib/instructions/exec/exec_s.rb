# Implements the S Combinator on the +:exec+ stack:
# if the top three items on the stack are A, B, C (in top-to-bottom order), this pushes
# 1. a CodeBlock containing B and C (in that order)
# 2. C
# 3. A
#
# *needs:* 3 +:exec+ items
#
# *pushes:* 3 +:exec+ items 
#

class ExecSInstruction < Instruction
  def preconditions?
    needs :exec, 3
  end
  def setup
    @argA = @context.pop(:exec)
    @argB = @context.pop(:exec)
    @argC = @context.pop(:exec)
  end
  def derive  
    @s_result = CodeblockPoint.new([@argB,@argC])
  end
  def cleanup
    pushes :exec, @s_result
    pushes :exec, @argC
    pushes :exec, @argA
  end
end
