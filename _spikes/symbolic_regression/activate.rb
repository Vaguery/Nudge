APP_ROOT = File.dirname(__FILE__)

require './../../lib/nudge.rb'
require APP_ROOT + '/config/environment.rb'

include Nudge


spike_factory = Factory.new(name:"spike")

# couchDB crap

# launch web server

# run forever, checking config now and then
5.times do
  
  100.times do 
    [Station.stations["generator1"],Station.stations["generator2"]].each {|station| station.core_cycle}
  end
  
  10.times do |gen|
    puts "\nGeneration #{gen}\n"
    Station.stations.each {|name, station| puts "#{name}, pop:#{station.population.length}"; station.core_cycle}
    
    Station.stations["level1"].cull_all if Station.stations["level1"].population.length > 1500
  end
  
  
  # Station.stations.each {|name, station| puts "#{name} has population: #{station.population.length}"}
  # 
  # ["level1","level2","level3","level4"].each do |station|
  #   if Station.stations[station].population.length > 20
  #     sorted = Station.stations[station].population.sort_by {|dude| dude.scores["errors"] || 100000}
  #     (0..20).each {|i| puts "#{sorted[i].scores}:\n#{sorted[i].genome}"}
  #   end
  # end
  # 
  # Station.stations["level1"].cull_all
end