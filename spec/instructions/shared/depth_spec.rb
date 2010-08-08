# encoding: UTF-8
require 'spec_helper'

%w(Bool Code Float Int Name Proportion).each do |name|
  exe = NudgeExecutable.new("block {}").step
  exe.stacks[:bool] << true
  exe.stacks[:bool] << false
  exe.stacks[:code] << "block {}"
  exe.stacks[:code] << "block {}"
  exe.stacks[:float] << 1.0
  exe.stacks[:float] << 2.0
  exe.stacks[:int] << 1
  exe.stacks[:int] << 2
  exe.stacks[:name] << :x
  exe.stacks[:name] << :y
  exe.stacks[:proportion] << 0.0909090909
  exe.stacks[:proportion] << 0.9090909091
  
  describe "#{name}Depth" do
    describe "#process" do
      it "pushes the length of the :#{name.downcase} stack to the :int stack" do
        NudgeInstruction.execute(:"#{name.downcase}_depth", exe)
        exe.stacks[:int].last.should == "2"
      end
    end
  end
end
