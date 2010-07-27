class CodeDoCount < NudgeInstruction
  get 1, :code
  get 1, :int
  
  def process
    new_tree = case 
      when int(0) < 0
        put :error,
          "code_do_count called with negative counter"
      when int(0) == 0
      when int(0) == 1
        put :exec,
          NudgePoint.from(code(0))
      else
        put :exec,
          BlockPoint.new(Value.new(:int,(int(0)-1)), DoPoint.new("exec_do_count"), NudgePoint.from(code(0)))
      end
  end
end
