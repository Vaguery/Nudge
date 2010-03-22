# coding: utf-8
module NudgeType
  
  class CodeType
    extend TypeBehaviors
    @@defaultPoints = 20
    
    def self.recognizes?(thing)
      return thing.kind_of?(String)
    end
    
    
    def self.from_s(string_value)
      return string_value.sub(/\(/,"«").sub(/\)/,"»")
    end
    
    def self.any_value(options = {})
      StringRewritingGenerator.new(options).generate
    end
  end
  
  
  
  
  class StringRewritingGenerator
    attr_accessor :incoming_options
    attr_accessor :target_size_in_points
    attr_accessor :probabilities
    attr_accessor :reference_names
    attr_accessor :type_names
    attr_accessor :instruction_names
    
    
    def initialize(options = {})
      @incoming_options = options
      @target_size_in_points = options[:target_size_in_points] || 20
      @probabilities = options[:probabilities] || {b:1, r:1, v:1, i:1}
      raise(ArgumentError, "probabilities Hash doesn't have necessary keys") unless
        @probabilities.keys.sort == [:b,:i,:r,:v]
      @probabilities.values.each {|v| raise(ArgumentError, "probabilities must be positive") if v < 0}
      raise(ArgumentError, "probability values must be positive") unless
        @probabilities.values.inject(:+) > 0
      
      
      @reference_names = options[:reference_names] || []
      @type_names = options[:type_names] ||
        NudgeType::all_types.collect {|t| t.to_nudgecode.to_s}
      @instruction_names = options[:instruction_names] ||
        Instruction.all_instructions.collect {|i| i.to_nudgecode.to_s}
    end
    
    
    def choose_weighted(normalized_hash)
      total = @probabilities.values.inject(:+)
      rand_sample = rand(total)
      @probabilities.each do |key,value|
        return key if rand_sample < value
        rand_sample -= value
      end
    end
    
    
    def generate
      top_and_bottom = self.filled_framework
      return "#{top_and_bottom[:code_part].strip} \n#{top_and_bottom[:footnote_part].strip}".strip
    end
    
    
    def backbone
      return "*" * @target_size_in_points
    end
    
    def open_framework(stars = self.backbone)
      stars[0]= 'b' if stars.length > 1 # because any long framework bust be in a block
      asteriskless = stars.gsub(/\*/) {|match| choose_weighted(@probabilities).to_s}
      return asteriskless
    end
    
    
    def closed_framework(without_braces = self.open_framework)
      braceless = /[b]([^{])/
      if without_braces[0] == 'b'
        without_braces << "}"
        without_braces.insert(1,'{')
      end
      
      with_some_braces = without_braces
      while with_some_braces.match(braceless)
        where = with_some_braces.index(braceless)
        with_some_braces.insert(where+1, '{')
        close_position = [where+rand(10)+1,with_some_braces.length].min
        while with_some_braces[close_position] == '{'
          close_position += 1
        end
        with_some_braces.insert(close_position,'} ')
      end
      return with_some_braces
    end
    
    
    def filled_framework(recipe = self.closed_framework)
      top, bottom = '',''
      recipe.chars do |c|
        case
        when c == 'b'
          top << 'block '
        when c == 'i'
          top << "do #{instruction_names.sample} "
        when c == 'r'
          ref_name = @reference_names.sample || next_name
          top << "ref #{ref_name} "
        when c == 'v'
          begin
            type_name = @type_names.sample || 'unknown'
            type_class = "#{type_name}_type".camelize.constantize
            reduced_size = rand(@target_size_in_points/4)
            reduced_option = {target_size_in_points:reduced_size}
            sampled_value = type_class.any_value(@incoming_options.merge(reduced_option)).to_s
          rescue NameError
            sampled_value = ""
          end
          top << "value «#{type_name}» "
          bottom << "\n«#{type_name}» #{sampled_value}"
        else
          top << c
        end
      end
      return {:code_part => top.strip, :footnote_part => bottom.strip}
    end
    
    
    def next_name
      @next_name = (@next_name || "aaa000").succ
    end
  end
end