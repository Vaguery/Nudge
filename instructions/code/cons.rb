class CodeCons < NudgeInstruction
  get 2, :code
  
  def process
    arg2 = NudgePoint.from(code(0))
    arg1 = NudgePoint.from(code(1))
    
    unless arg1.is_a?(NilPoint) || arg2.is_a?(NilPoint)
      arg2 = BlockPoint.new(arg2) unless arg2.kind_of?(BlockPoint)
      arg2.insert_point_before(1,arg1)
      put :code, arg2.to_script
    else
      put :error, "code_cons cannot parse an argument"
    end
  end
end
