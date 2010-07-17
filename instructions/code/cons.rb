class CodeCons < NudgeInstruction
  get 2, :code
  
  def process
    arg2 = NudgePoint.from(code(0))
    arg1 = NudgePoint.from(code(1))
    arg2 = BlockPoint.new(arg2) unless arg2.kind_of?(BlockPoint)
    arg2.insert_point_before(1,arg1)
    put :code, arg2.to_script
  end
end
