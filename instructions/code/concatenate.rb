class CodeConcatenate < NudgeInstruction
  get 2, :code
  
  def process
    arg2 = NudgePoint.from code(0)
    arg1 = NudgePoint.from code(1)
    
    result = if arg1.is_a?(BlockPoint)
      if arg2.is_a?(BlockPoint)
        
      else
        arg1.insert_point_after(arg1.points-1,arg2)
        arg1
      end
    else
      BlockPoint.new(arg1,arg2)
    end
    
    put :code, result.to_script
  end
end
