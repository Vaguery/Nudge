class CodeCar < NudgeInstruction
  get 1, :code
  
  def process
    prog = NudgePoint.from(code(0))
    unless prog.kind_of?(NilPoint)
      result = prog.is_a?(BlockPoint) && (prog.points > 1) ? prog.get_point_at(1).to_script : code(0)
      put :code, result
    else
      put :error, "code_car cannot parse an argument"
    end
  end
end
