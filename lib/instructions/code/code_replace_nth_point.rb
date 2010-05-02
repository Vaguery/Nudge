# pops the top two +:code+ items ("host" and "target"), and one +:int+ item (the "index");
# pushes a new +:code+ item, which is the +index+th program point of the +host+
# is replaced by the +target+ (as a subtree)
#
# note: order of arguments is important; the top +:code+ item is the "target" argument
#
# *needs:* 2 +:code+, 1 +:int+
#
# *pushes:* 1 +:code+
#

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
    new_tree = acceptor.replace_point(which_pt, insertion.linked_code).blueprint
    @result = ValuePoint.new("code", new_tree)
  end
  def cleanup
    pushes :code, @result
  end
end
