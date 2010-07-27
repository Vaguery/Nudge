class ExecDoRange < NudgeInstruction
  get 1, :exec
  get 2, :int
  
  def process
    start_int = int(1)
    end_int = int(0)
    
    if start_int == end_int
      put :exec, exec(0)
    else
      put :exec, BlockPoint.new(
        Value.new(:int,(start_int + (start_int < end_int ? 1 : -1))),
        Value.new(:int,(end_int)),
        DoPoint.new("exec_do_range"),
        exec(0))
    end
      
      put :int, start_int
      
  end
end
