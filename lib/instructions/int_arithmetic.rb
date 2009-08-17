require File.join(File.dirname(__FILE__), "./infrastructure.rb")

module Instructions
  module Int_Arithmetic
    
    module Int_Arity2
      def initialize(context=nil)
        @context = context
        @requirements = {:int => 2}
        @effects = {:int => 1}
      end
      
      def run()
        if ready? then
          arg2 = @context.stacks[:int].pop
          arg1 = @context.stacks[:int].pop
          result = detail(arg1,arg2)
          @context.stacks[:int].push result
        else
          @context.NOOPs += 1
          result = "NOOP"
        end
        return result # for testing
      end
      
      def detail(*)
      end
    end
    
    
    
    class Int_add < Instruction
      include Int_Arity2
      
      def detail(arg1, arg2)
        return Literal.new(:int, arg1.value + arg2.value)
      end
    end
    
    
    class Int_subtract < Instruction
      include Int_Arity2
      
      def detail(arg1, arg2)
        return Literal.new(:int, arg1.value - arg2.value)
      end
    end
    
  end
end