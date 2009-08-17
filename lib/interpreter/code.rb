module Nudge  
  class Code
    @@badArgumentMessage = "Unrecognized class appears in Code.contents"
    @@validFirstWords = ['literal', 'erc', 'instr', 'binding', 'block']
    
    attr_accessor :listing
    
    def initialize(code_string = "")
      @listing=code_string
    end
    
    def points
      return @listing.scan(/.+$/).size
    end
    
    def every_line
      return @listing.scan(/.+$/)
    end
    
    def unwrap_block(block)
    end
    
    
    
    def valid?
      return validate_empty(@listing) || valid_firstword?(@listing)
    end
    
    def validate_empty(code)
      return code == ""
    end
    
    def valid_firstword?(line, valid_words = @@validFirstWords)
      return valid_words.include?(line.downcase.split[0])
    end
        
  end
end