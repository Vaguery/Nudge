# Pragmatic Genetic Programming

The first release of the Pragmatic GP package will include a Ruby implementation of a [Push 3.0 language interpreter](http://hampshire.edu/lspector/push3-description.html "Push 3"), a framework for setting up and managing straightforward genetic programming projects using an [ALPS](http://idesign.ucsc.edu/projects/alps.html "ALPS algorithms")-based algorithm, and a simple architecture for monitoring and exploring the results of GP runs as they arise.

This is a complete rewrite of an earlier project written in Python, and is really just a huge down-to-the-roots refactoring that relies on a lot of Ruby's more convenient metaprogramming features.

We're building this from the bottom up, so it doesn't "work" in the sense you might expect. At the moment, only the specs pass. There isn't any centralized run behavior in place yet, though that will be coming soon.

## Requirements

For the time being requirements need to be installed by hand.

First, the codebase increasingly relies on features of ruby 1.9.1. If you'd like to work with it, I'd recommend using [rvm](http://rvm.beginrescueend.com/) to set it up to work alongside the other version(s) of the Ruby interpreter your system may depend on.

You'll need to download and install [couchDB](http://couchdb.apache.org/), and have it running before launching a full-fledged Nudge Experiment.

To run and verify the codebase, you'll need to have recent versions of the following gems: [haml](http://haml-lang.com/), [sinatra](http://www.sinatrarb.com/), [treetop](http://treetop.rubyforge.org/), [activesupport](http://as.rubyonrails.org/), and [couchrest](http://github.com/jchris/couchrest); [rspec](http://rspec.info/), [cucumber](http://cukes.info/) and [fakeweb](http://fakeweb.rubyforge.org/) to be able to run the specs and confirm the codebase works on your system.

If as we are you're developing with TextMate, you'll need to make sure your 'PATH' variable in the application is set correctly by adding the path to your *active* ruby binary and gems to the front.