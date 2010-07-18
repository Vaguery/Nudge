class CodeBundle < NudgeInstruction
  get 1, :int
  
  def process
    stacks = @outcome_data.stacks
    
    number_to_bundle = int(0)
    code_depth = stacks[:code].length
    
    return if number_to_bundle < 0
    
    starting_index = code_depth - [number_to_bundle, code_depth].min
    chunks = stacks[:code].slice!(starting_index..-1)
    script = chunks.join(" ")
    put :code, "block {#{script}}"
  end
end
