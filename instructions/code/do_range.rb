class CodeDoRange < NudgeInstruction
  get 1, :code
  get 2, :int
  
  def process
    start_int = int(1)
    end_int = int(0)
    
    if start_int == end_int
      put :exec, NudgePoint.from(code(0))
    else
      put :exec, BlockPoint.new(
        Value.new(:int,(start_int + (start_int < end_int ? 1 : -1))),
        Value.new(:int,(end_int)),
        DoPoint.new("exec_do_range"),
        NudgePoint.from(code(0)))
    end
      
      put :int, start_int
      
  end
end
