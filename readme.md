# Pragmatic Genetic Programming

The first release of the Pragmatic GP package will include a Ruby implementation of a [Push 3.0 language interpreter](http://hampshire.edu/lspector/push3-description.html "Push 3"), a framework for setting up and managing straightforward genetic programming projects using an [ALPS](http://idesign.ucsc.edu/projects/alps.html "ALPS algorithms")-based algorithm, and a simple architecture for monitoring and exploring the results of GP runs as they arise.

This is a complete rewrite of an earlier project written in Python, and is really just a huge down-to-the-roots refactoring that relies on a lot of Ruby's more convenient metaprogramming features.

We're building this from the bottom up, so it doesn't "work" in the sense you might expect. At the moment, only the specs pass. There isn't any centralized run behavior in place yet, though that will be coming soon.