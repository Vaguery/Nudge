require './nudge'

%w(Bool Code Exec Float Int Proportion).each do |name|
  outcome_data = Outcome.new({})
  outcome_data.stacks[:bool].push "true"
  outcome_data.stacks[:code].push "block {}"
  outcome_data.stacks[:exec].push NudgePoint.from("block {}")
  outcome_data.stacks[:float].push "1.0"
  outcome_data.stacks[:int].push "1"
  outcome_data.stacks[:proportion].push "0.0909090909"
  
  outcome_data.stacks[:name].push "x"
  
  describe "Instruction::#{name}Define" do
    describe "#process()" do
      it "pops the top items off the :#{name.downcase} stack and the :name stack, then binds the #{name.downcase} value to a variable with that name" do
        variable_name = outcome_data.stacks[:name][-1].intern
        expected_value = outcome_data.stacks[name.downcase.intern][-1]
        Instruction.execute(:"#{name.downcase}_define", outcome_data)
        outcome_data.stacks[:name].length.should == 0
        outcome_data.stacks[name.downcase.intern].length.should == 0
        outcome_data.variable_bindings[variable_name].instance_variable_get(:@string).should == expected_value
      end
    end
  end
end
