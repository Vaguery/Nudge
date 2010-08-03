# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))

%w(Code Float Int Name Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
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
  
  exe.stacks[:bool] << true
  
  describe "#{name}If" do
    describe "#process" do
      it ":#{name.downcase} stack" do
        expected_new_top_value = exe.stacks[name.downcase.intern][-2]
        NudgeInstruction.execute(:"#{name.downcase}_if", exe)
        exe.stacks[name.downcase.intern][-1].should == expected_new_top_value
      end
    end
  end
end
