# pops the top item from the +:code+ stack;
# pushes an +:int+ with the number of items <i>in the root</i> of the +:code+ value
#
# note: if the +:code+ value does not parse, or is an atom (doesn't parse into a CodeBlockPoint),
# the result is 0; if it is an empty block, it's also 0
#
# For example:
#   [1,2,[3,4],5] -> 4 backbone points
#   [[1,2,3,4,5]] -> 1 backbone point
#   [] -> 0 backbone points
#   1 -> 0 backbone points
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:int+
#

class CodeBackbonePointsInstruction < Instruction
  
  def preconditions?
    needs :code, 1
  end
  
  def setup
    arg_blueprint = @context.pop_value(:code)
    @parsed = NudgeProgram.new(arg_blueprint)
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
