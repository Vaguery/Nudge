#encoding: utf-8
class NudgeWriter
  attr_accessor :weight, :block_width, :block_depth
  attr_accessor :do_instructions, :ref_names, :value_types
  attr_accessor :code_recursion, :float_range, :int_range
  
  def initialize
    @weight = {:block => 1, :do => 1, :ref => 1, :value => 1}
    @block_width = 5
    @block_depth = 5
    
    @do_instructions = NudgeInstruction::INSTRUCTIONS.keys
    @ref_names = %w:x1 x2 x3 x4 x5 x6 x7 x8 x9 x10:
    @value_types = NudgeValue::TYPES.keys
    
    @code_recursion = 5
    @float_range = -100..100
    @int_range = -100..100
    
    yield self if block_given?
    
    @footnotes_needed = []
    @include_code_type = @value_types.delete(:code)
    
    @min_float, @max_float = [@float_range.min, @float_range.max].sort
    @min_int, @max_int = [@int_range.min, @int_range.max].sort
    
    total_weight = (@weight[:block] + @weight[:do] + @weight[:ref] + @weight[:value]).to_f
    
    do_start = (@weight[:block]) / total_weight
    ref_start = (@weight[:block] + @weight[:do]) / total_weight
    value_start = (@weight[:block] + @weight[:do] + @weight[:ref]) / total_weight
    
    @block = 0...do_start
    @do = do_start...ref_start
    @ref = ref_start...value_start
  end
  
  def random
    "#{generate!(@block_depth)}\n#{footnotes!}"
  end
  
  def generate! (remaining_depth)
    points = (0...@block_width).collect { random_point(remaining_depth) }
    points.length > 1 ? "block { #{points.compact.join(" ")} }" : points
  end
  
  def footnotes!
    footnotes = []
    code_recursion, include_code_type = @code_recursion, @include_code_type
    
    while value_type = @footnotes_needed.pop
      footnotes << "«#{value_type}»#{random_value(value_type)}"
    end
    
    @code_recursion, @include_code_type = code_recursion, include_code_type
    footnotes.join("\n")
  end
  
  def random_point (remaining_depth)
    case rand
      when @block then generate!(remaining_depth - 1) if remaining_depth > 0
      when @do    then "do #{@do_instructions.shuffle.first}"
      when @ref   then "ref #{@ref_names.shuffle.first}"
    else
        value_types = @value_types + (@include_code_type ? [:code] : [])
        value_type = value_types.shuffle.first
        
        @footnotes_needed << value_type
        "value «#{value_type}»"
    end
  end
  
  def random_value (value_type)
    case value_type
      when :bool       then rand < 0.5
      when :float      then rand(@max_float - @min_float).to_f + @min_float
      when :int        then rand(@max_int - @min_int).to_i + @min_int
      when :name       then @ref_names.shuffle.first
      when :proportion then rand
      when :code
        @include_code_type = (@code_recursion -= 1) >= 0
        generate!(@block_depth)
    else
      NudgeValue::TYPES[value_type].random
    end.to_s
  end
end
