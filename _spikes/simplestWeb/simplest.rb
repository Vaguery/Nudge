require 'sinatra'
require '../../lib/nudge'

include Nudge

Spike = Experiment.new(name:"spiker")
CurrentCount = 871

get '/' do
  erb :main
end

get '/instructions' do
  Spike.instructions = Instruction.all_instructions
  redirect '/'
end

get '/types' do
end

get '/stations' do
end

get '/go' do
  # run 10 steps
  10.times do
    Station.stations.each {|name, station| puts "running #{name}"; station.core_cycle}
  end
end