APP_ROOT = File.dirname(__FILE__)

require '../../lib/nudge.rb'
require APP_ROOT + '/config/environment.rb'

include Nudge

spike_experiment = Experiment.new(name:"spike")

# couchDB crap

# launch web server

# run forever, checking config now and then
10.times do
  Station.stations.each {|name, station| puts "#{name}"; station.core_cycle}
end


Station.stations.each {|name, station| puts "#{name} has population: #{station.population.length}"}