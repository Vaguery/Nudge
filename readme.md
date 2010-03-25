# Nudge Language Interpreter in Ruby

Nudge is a flexible programming language descended from the [Push 3.0 language](http://hampshire.edu/lspector/push3-description.html "Push 3"). It's a stack-based language with a very simple interpreter, and 

## Requirements

The interpreter code relies heavily on functional programming features of Ruby 1.9+. If you have not yet installed Ruby 1.9, I'd recommend using [rvm](http://rvm.beginrescueend.com/) to set up a special "sandbox" version of 1.9 until you're ready to upgrade your development or production machine.

The following gems need to be present to run the code:
  * [treetop](http://treetop.rubyforge.org/)
  * [activesupport](http://as.rubyonrails.org/)
  
and you will want [rspec](http://rspec.info/) to be able to run the specs and confirm the codebase works on your system.