APP_ROOT = File.dirname(__FILE__)

require '../../lib/nudge.rb'
require APP_ROOT + '/config/environment.rb'

include Nudge

spike_experiment = Experiment.new(name:"spike")

# let's try to create a Station or two
@gen1 = Station.new("generator1", 10) 
@gen2 = Station.new("generator2", 10) 

# couchDB crap

# launch web server

# run forever, checking config now and then
10.times do
  Station.stations.each {|name, station| puts "running #{name}"; station.core_cycle}
end