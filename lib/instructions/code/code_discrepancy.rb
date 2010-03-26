# ORIGINAL DESCRIPTION in Push3:
# Pushes a measure of the discrepancy between the top two CODE stack items onto the INTEGER stack. This will be zero if the top two items are equivalent, and will be higher the 'more different' the items are from one another. The calculation is as follows:
# 1. Construct a list of all of the unique items in both of the lists (where uniqueness is determined by equalp). Sub-lists and atoms all count as items.
# 2. Initialize the result to zero.
# 3. For each unique item increment the result by the difference between the number of occurrences of the item in the two pieces of code.
# 4. Push the result.


class CodeDiscrepancyInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
     # collect string listings of every point
    parts_of_1 = NudgeProgram.new(@arg1).linked_code.collect {|pt| pt.listing}
    parts_of_2 = NudgeProgram.new(@arg2).linked_code.collect {|pt| pt.listing}
    unique_parts = (parts_of_1.uniq + parts_of_2.uniq).reject {|i| i == ""}
    summed_differences = unique_parts.inject(0) {|sum, uniq_string| sum +
      (parts_of_2.count(uniq_string) - parts_of_1.count(uniq_string)).abs}
    @result = ValuePoint.new("int", summed_differences)
  end
  def cleanup
    pushes :int, @result
  end
end
