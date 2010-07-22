class CodeReverse < NudgeInstruction
  get 1, :code
  
  def process
    tree = NudgePoint.from(code(0))
    result = tree.kind_of?(BlockPoint) ? BlockPoint.new(*tree.instance_variable_get(:@points).reverse).to_script : code(0)
    put :code, result
  end
end
