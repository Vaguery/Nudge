# Nudge Language Interpreter in Ruby

Nudge is a flexible programming language descended from [Push 3.0](http://hampshire.edu/lspector/push3-description.html "Push 3"). It's an extensible stack-based language with a very simple interpreter structure, but a lot of functionality.

Like Push, Nudge is _usable_ by human beings, but it's actually designed for genetic programming applications. Unlike Push, we've incorporated a lot of syntactic sugar to make it a bit more human-readable (even when machine-generated), and this library implements simple mechanisms for passing in problem-specific variables and extending the core language by writing new instructions.

See the [project Wiki](http://github.com/Vaguery/Nudge/wikis) for a more thorough explanation.

## Getting started

    gem install nudge

As of this writing, the `nudge` gem can be used as a library in your Ruby programs. S Real Soon Now, it'll be part of a more interesting gem…

Meanwhile, try something like this:

    #encoding: utf-8
    # you'll need to use unicode for all Nudge programs
    
    require 'nudge'
    include Nudge
    
    my_program = NudgeProgram.random(
      :target_size_in_points => 50,
      :reference_names => ["x1", "x2"])
    
    puts "Your random program:\n\n#{my_program.blueprint}"
    
    my_interpreter = Interpreter.new()
    
    my_interpreter.reset(my_program.blueprint)
    
    
    # set up some sensors, so we know what happens afterwards
    my_interpreter.register_sensor("int_1") {|state| state.peek_value(:int)} # reads the top :int value
    my_interpreter.register_sensor("bool_1") {|state| state.peek_value(:bool)} # reads the top :bool value
    my_interpreter.register_sensor("steps") {|state| state.steps} # reads the number of steps the interpreter took
    
    puts "\n\nsensor values: #{my_interpreter.run}"

When you run that, you'll get something like this:

<script src="http://gist.github.com/347215.js?file=nudge_sample_output.txt"></script>

## Requirements

The interpreter code relies heavily on functional programming features of Ruby 1.9+. If you have not yet installed Ruby 1.9, I'd recommend using [rvm](http://rvm.beginrescueend.com/) to set up a special "sandbox" version of 1.9 until you're ready to upgrade your development or production machine.

The following gems need to be present to run the code:

* [treetop](http://treetop.rubyforge.org/)
* [activesupport](http://as.rubyonrails.org/)
  
and you will want [rspec](http://rspec.info/) to be able to run the specs and confirm the codebase works on your system.