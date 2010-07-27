class ExecDoCount < NudgeInstruction
  get 1, :exec
  get 1, :int
  
  def process
    new_tree = case 
      when int(0) < 0
        put :error,
          "exec_do_count called with negative counter"
      when int(0) == 0
      when int(0) == 1
        put :exec,
          exec(0)
      else
        put :exec,
          BlockPoint.new(Value.new(:int,(int(0)-1)), DoPoint.new("exec_do_count"), exec(0))
      end
  end
end
