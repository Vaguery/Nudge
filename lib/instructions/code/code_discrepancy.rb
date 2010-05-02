# pops the top 2 items of the +:code+ stack;
# and compares their values algorithmically to obtain an +:int+ value, which it pushes
#
# The measure of discrepancy is determined by:
# 1. first creating a list of every program point's blueprint, for both +:code+ values
# 2. for every item in the _union_ of these sets of blueprints, accumulate the absolute difference in the number of times the blueprint appears in each of the two items' values
#
# the resulting +:int+ is pushed
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:int+
#

class CodeDiscrepancyInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
     # collect string blueprints of every point
    parts_of_1 = NudgeProgram.new(@arg1).linked_code.collect {|pt| pt.blueprint}
    parts_of_2 = NudgeProgram.new(@arg2).linked_code.collect {|pt| pt.blueprint}
    unique_parts = (parts_of_1.uniq + parts_of_2.uniq).reject {|i| i == ""}
    summed_differences = unique_parts.inject(0) {|sum, uniq_string| sum +
      (parts_of_2.count(uniq_string) - parts_of_1.count(uniq_string)).abs}
    @result = ValuePoint.new("int", summed_differences)
  end
  def cleanup
    pushes :int, @result
  end
end
