class CodeConcatenate < NudgeInstruction
  get 2, :code
  
  def process
    arg2 = NudgePoint.from code(0)
    arg1 = NudgePoint.from code(1)
    
    pts = arg1.is_a?(BlockPoint) ? arg1.instance_variable_get(:@points) : [arg1]
    pts += (arg2.is_a?(BlockPoint) ? arg2.instance_variable_get(:@points) : [arg2])
    
    put :code, BlockPoint.new(*pts).to_script
  end
end
