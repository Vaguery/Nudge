class CodeNthCdr < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    arg1 = NudgePoint.from(code(0))
    arg1 = BlockPoint.new(arg1) unless arg1.kind_of?(BlockPoint)
    arg2 = [arg1.points-1,[int(0).to_i,0].max].min
    
    arg2.times {arg1.delete_point_at(1)} 
    put :code, arg1.to_script
  end
end
