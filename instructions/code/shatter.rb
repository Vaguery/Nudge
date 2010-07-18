class CodeShatter < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    @points = []
    get_points(tree, int(0))
    
    @points.each {|pt| put :code, pt}
  end
  
  def get_points (tree, depth)
    if block_points = tree.instance_variable_get(:@points)
      if depth <= 0
        @points << tree.to_script
      else
        block_points.each do |point|
          get_points(point, depth - 1)
        end
      end
    else
      @points << tree.to_script
    end
  end
end
