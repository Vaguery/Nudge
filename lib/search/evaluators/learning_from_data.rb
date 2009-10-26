module Nudge
  
    class SummedSquaredError < Evaluator
      @@defaultPenalty = 1000000
      
      attr_accessor :name, :penalty

      def initialize(penalty = nil)
        @name = :summed_squared_error
        @penalty = (penalty || @@defaultPenalty)
      end
      
      def aggregate(resultsList)
        raise ArgumentError if !resultsList.kind_of?(Array)
        sse = resultsList.inject(0) do |sum,r|
          if r.observed
            sum + (r.expected - r.observed)**2
          else
            sum + @penalty
          end
        end
        return sse
      end

    end
    
end