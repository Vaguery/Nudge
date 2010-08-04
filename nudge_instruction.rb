# encoding: UTF-8
class NudgeInstruction
  INSTRUCTIONS = {}
  
  def NudgeInstruction.inherited (klass)
    klass.const_set("REQUIREMENTS", {})
    
    instruction_name = klass.name.
      gsub(/^.*::/, '').
      gsub(/Q$/,'?').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      gsub(/([^\d])([\d])/,'\1_\2').
      downcase.intern
    
    INSTRUCTIONS[instruction_name] = klass
    
    def klass.get (n, value_type)
      self::REQUIREMENTS[value_type] = n
      define_method(value_type) {|i| raise if i >= n; @arguments[value_type][i] }
    end
  end
  
  def NudgeInstruction.execute (instruction_name, executable)
    unless instruction_class = INSTRUCTIONS[instruction_name]
      raise NudgeError::UnknownInstruction, "#{instruction_name} not recognized"
    end
    
    stacks = executable.stacks
    
    instruction_class::REQUIREMENTS.each do |value_type, n|
      unless stacks[value_type].length >= n
        raise NudgeError::MissingArguments, "#{instruction_name} missing arguments"
      end
    end
    
    instruction_class.new(executable).execute
  end
  
  def initialize (executable)
    @executable = executable
    @arguments = Hash.new {|hash, key| hash[key] = [] }
  end
  
  def execute
    stacks = @executable.stacks
    
    self.class::REQUIREMENTS.each do |value_type, n|
      stack = stacks[value_type]
      arguments = @arguments[value_type]
      
      n.times { arguments << stack.pop_value }
    end
    
    process
  end
  
  def put (value_type, result)
    @executable.stacks[value_type] << result
  end
end
