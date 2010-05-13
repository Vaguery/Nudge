module NudgeType
  
  class ProportionType
    extend TypeBehaviors
    @default_lowest = 0.0
    @default_highest = 1.0

    def self.default_lowest
      @default_lowest
    end

    def self.default_highest
      @default_highest
    end

    def self.random_value(params = {})
      bottom = params[:proportion_lower_bound] || @default_lowest
      top = params[:proportion_upper_bound] || @default_highest
      raise ArgumentError, "ProportionType#{random_value} bounds must be in range [0.0,1.0]" unless
        (0.0..1.0).include?(bottom) && (0.0..1.0).include?(top)
      raise ArgumentError, "ProportionType#{random_value} bounds are inverted" unless
        bottom <= top
      range = top - bottom
      (rand*range) + bottom
    end
    
    def self.from_s(string_value)
      return string_value.to_f % 1.0
    end
    
    def self.recognizes?(a_thing)
      !a_thing.kind_of?(String) && !a_thing.nil? && a_thing.respond_to?(:to_f)
    end
    
    def self.any_value(options ={})
      self.random_value(options)
    end
  end
end