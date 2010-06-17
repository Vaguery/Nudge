require 'nudge'

describe "BlockPoint" do
  describe ".new(*points)" do
    it "returns a new BlockPoint containing an array of the given points" do
      point_1 = BlockPoint.new
      point_2 = BlockPoint.new
      
      BlockPoint.new(point_1, point_2).instance_variable_get(:@points) == [point_1, point_2]
    end
  end
  
  describe "#evaluate(outcome_data)" do
    it "pushes its points onto the exec stack in reverse order" do
      outcome_data = Outcome.new({})
      
      point_1 = BlockPoint.new
      point_2 = BlockPoint.new
      point_3 = BlockPoint.new
      
      BlockPoint.new(point_1, point_2, point_3).evaluate(outcome_data)
      
      outcome_data.stacks[:exec][2].should === point_1
      outcome_data.stacks[:exec][1].should === point_2
      outcome_data.stacks[:exec][0].should === point_3
    end
  end
end
