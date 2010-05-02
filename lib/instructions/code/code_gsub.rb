# pops three items from the +:code+ stack: the "host", the "old_subtree" and the "new_subtree";
# pushes a new +:code+ item which contants the +host+, with every occurrence of the +old_subtree+
# (if any) replaced by the +new_subtree+
#
# note: the order of arguments counts; the top +:code+ stack item is the +host+, 
# the second is the +old_subtree+, and the third is the +new_subtree+
#
# *needs:* 3 +:code+
#
# *pushes:* 1 +:code+
#

class CodeGsubInstruction < Instruction # was CODE.SUBST in Push3
  def preconditions?
    needs :code, 3
  end
  def setup
    @host_tree = @context.pop_value(:code)
    @old_subtree = @context.pop_value(:code)
    @new_subtree = @context.pop_value(:code)
  end
  def derive
    new_tree = NudgeProgram.new(@new_subtree)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless new_tree.parses?
    old_tree = NudgeProgram.new(@old_subtree)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless old_tree.parses?
    host = NudgeProgram.new(@host_tree)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} cannot work with unparseable code" unless host.parses?
    
    found_at = [] # need to iterate through the tree the slow way to capture the indices (I think)
    host.linked_code.each_with_index do |point, index|
      found_at << (index+1) if point.blueprint == old_tree.blueprint
    end
    found_at.reverse.each {|index| host = host.replace_point(index, new_tree.linked_code)}
    @result = ValuePoint.new("code", host.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
