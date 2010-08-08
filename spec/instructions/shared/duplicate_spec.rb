# encoding: UTF-8
require 'spec_helper'

%w(Bool Code Float Int Name Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
  exe.stacks[:bool] << true
  exe.stacks[:code] << "block {}"
  exe.stacks[:float] << 1.0
  exe.stacks[:int] << 1
  exe.stacks[:name] << :x
  exe.stacks[:proportion] << 0.0909090909
  
  describe "#{name}Duplicate" do
    describe "#process" do
      it "pushes a duplicate of the top item on the :#{name.downcase} stack to the :#{name.downcase} stack" do
        NudgeInstruction.execute(:"#{name.downcase}_duplicate", exe)
        exe.stacks[name.downcase.intern][-1].should == exe.stacks[name.downcase.intern][-2]
      end
    end
  end
end
