# ORIGINAL PUSH3 DESCRIPTION: Pushes the result of substituting the third item on the code stack for the second item in the first item. As of this writing this is implemented only in the Lisp implementation, within which it relies on the Lisp "subst" function. As such, there are several problematic possibilities; for example "dotted-lists" can result in certain cases with empty-list arguments. If any of these problematic possibilities occurs the stack is left unchanged.

# Here, we will pop three :code items, find all occurrences of the appropriate point in the changed codeblock, and then replace them in last-to-first order (so the point counts discovered initially don't change during substitution)

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
      found_at << (index+1) if point.listing == old_tree.listing
    end
    found_at.reverse.each {|index| host = host.replace_point(index, new_tree.linked_code)}
    @result = ValuePoint.new("code", host.listing)
  end
  def cleanup
    pushes :code, @result
  end
end
