module Nudge
  
  class Channel
    attr_accessor :name, :source
    
    def initialize(name, source = {})
      if name.kind_of? String
        @name = name
      else
        raise TypeError, "Channel must have a string name"
      end
      
      if source.kind_of? Hash
        @source = source
      else
        raise TypeError, "Channel source must be a hash"
      end
    end
    
    
    def source
      return @source
    end
    
    def source=(s)
      if s.kind_of?(Hash)
        @source = s
      else
        raise TypeError, "Channel source must be a hash"
      end
    end
    
    def value
      tentative = @source[@name]
      if tentative.kind_of?(Literal)
        return @source[@name]
      else
        raise TypeError, "Channel does not return a Literal"
      end
    end
  end
  
end