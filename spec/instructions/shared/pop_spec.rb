# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

%w(Bool Code Float Int Name Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
  exe.stacks[:bool] << true
  exe.stacks[:bool] << false
  exe.stacks[:code] << "block {}"
  exe.stacks[:code] << "block { do int_add }"
  exe.stacks[:float] << 1.0
  exe.stacks[:float] << 2.0
  exe.stacks[:int] << 1
  exe.stacks[:int] << 2
  exe.stacks[:name] << :x
  exe.stacks[:name] << :y
  exe.stacks[:proportion] << 0.1
  exe.stacks[:proportion] << 0.2
  
  describe "#{name}Pop" do
    describe "#process" do
      it "pops the top item off of the :#{name.downcase} stack" do
        expected_new_top_value = exe.stacks[name.downcase.intern][-2]
        NudgeInstruction.execute(:"#{name.downcase}_pop", exe)
        
        exe.stacks[name.downcase.intern].last.should == expected_new_top_value
      end
    end
  end
end
