class CodeFlatten < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    tree = NudgePoint.from(code(0))
    @pts = []
    get_points(tree, int(0))
    result = @pts.length > 1 ? BlockPoint.new(*@pts) : tree
    put :code, result.to_script
  end
  
  def get_points (tree, depth)
    if block_points = tree.instance_variable_get(:@points)
      if depth <= 0
        @pts = block_points
      else
        block_points.each do |point|
          get_points(point, depth - 1)
        end
      end
    else
      @pts << tree
    end
  end
end
