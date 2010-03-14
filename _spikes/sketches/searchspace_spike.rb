require 'nudge'

# classic generational GP

@params = # types, instructions, variable names, config settings for random code, &c

@guessOne = RandomGuess.new()
@selector = TournamentSelection.new()
@xover = FairCrossover.new()
@mutator = ErcHillclimb.new()
@elitism = ElitistClone.new()


initial_generator =
  Proc.new do
    newDude = @guessOne.generate(params, 1)
    newDude.keep
  end
  
  
generationalGP_generator =
  Proc.new do
    pop = self.population
    @elitism.generate(pop).keep
      # Clones the current best (nondominated) in pop; keeps them all; gen += 1
    500.times do
      parents = @selector.generate(pop,:tournament_size => 10, :collect => 1000) # Array of 1000 Individuals
      kid = @xover.generate(parents) # Returns an Array of 500 kids (parents used pairwise) 
      polished = @mutator.generate(kid,:prob => 0.01, :steps => 10)
      # Array with 500 individuals,
        # 99% cloned, 1%
        # the result of 10 steps of greedy hillclimbing
      polished.keep # keeps all 500 kids, all with gen += 1
      
    end
  end
  
  
generationalGP_culler =
  Proc.new do
    min_age = (self.population.collect {|indiv| indiv.gen}).min
    self.population.cull {indiv.gen <= min_age}
  end



source = SearchDaemon.new(
          :capacity => 0,
          :promote => {true},
          :activation => {true},
          :generator => initial_generator,
          :cull_by => {},
          :connects_to => coreLooper)



coreLooper = SearchDaemon.new(
        :activation => {self.population >= self.capacity},
        :capacity => 500,
        :cull_by => generationalGP_culler,
        :generator => generationalGP_generator
        # :connects_to nowhere else
        )

=begin
  The basic loop for a SearchDaemon is:
  0. IF you are active per your rule, then:
    1. cull per your rule, but only if you are over-capacity
    2. run your generator
    3. promote per your rules
  0' if inactive, do nothing
  
  So basically what will happen here is:
  * The source daemon is active all the time.
  * It generates one random guy every turn.
  * It has no capacity, so it will first try its #promote method
  * That will work; the guy will be "sent to" coreLooper
  * It has an empty Proc for its #cull method, but should have no population anyway so this won't fire
  
  * The coreLooper daemon is not active until 500 random guys have been added to it
  * It isn't over-capacity (it just activated because it contains 500 dudes), so no cull
  * runs its generator, which makes 500 new dudes with gen=1
  * it keeps all those kids, plus the old generation
  * it has nowhere to promote to
  
  * the source makes one new dude, sends it to the coreLooper
  * the coreLooper has pop = 1001; it culls until pop <= 500
  ** it iterates killing off the lowest-gen individuals: all the 501 gem=0 ones, this time
  * with 500 gen = 1 kids, it runs its generator again
  
  * the source makes one new dude, sends it to the coreLooper
  * the coreLooper has pop = 1001; it culls until pop <= 500
  ** it iterates killing off the lowest-gen individuals: the one gem=0 one from the source
  ** then it kills the 500 leftover parents from the previous generation
  * with 500 gen = 1 kids, it runs its generator again
  
  and so on, forever...
=end