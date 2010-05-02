# pops the top two +:code+ items;
# pushes a new +:int+ item, with value equal to the program point number in the first argument
# where the second argument appears as a subtree (or 0 otherwise)
#
# note: order of arguments is important; the top stack item is the second argument
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:int+
#

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
      index = inside_this.find_index {|point| point.blueprint == looking_for_this.blueprint} || -2
    else
      index = -2
    end
    @result = ValuePoint.new("int", index+1)
  end
  def cleanup
    pushes :int, @result
  end
end
