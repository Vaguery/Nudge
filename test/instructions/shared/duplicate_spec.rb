require './nudge'

%w(Bool Code Exec Float Int Name Proportion).each do |name|
  outcome_data = Outcome.new({})
  outcome_data.stacks[:bool].push "true"
  outcome_data.stacks[:code].push "block {}"
  outcome_data.stacks[:exec].push NudgePoint.from("block {}")
  outcome_data.stacks[:float].push "1.0"
  outcome_data.stacks[:int].push "1"
  outcome_data.stacks[:name].push "x"
  outcome_data.stacks[:proportion].push "0.0909090909"
  
  describe "Instruction::#{name}Duplicate" do
    describe "#process()" do
      it "pushes a duplicate of the top item on the :#{name.downcase} stack to the :#{name.downcase} stack" do
        Instruction.execute(:"#{name.downcase}_duplicate", outcome_data)
        outcome_data.stacks[name.downcase.intern].pop.should == outcome_data.stacks[name.downcase.intern].pop
      end
    end
  end
end
