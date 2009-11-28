require 'sinatra'
require '../../lib/nudge'

include Nudge

Spike = Experiment.new(name:"spiker")

Spike.instructions = []
Spike.types = []
Spike.station_names = []


get '/' do
  erb :main
end

get '/instructions' do
  Spike.instructions = Instruction.all_instructions
  redirect '/'
end

get '/types' do
  Spike.types = [IntType, BoolType, FloatType]
  redirect '/'
end

get '/stations' do
  redirect '/'
end

get '/go' do
  # run 10 steps
  10.times do
    Spike.station_names.each {|name| puts "running #{name}"; Station.stations[name].core_cycle}
  end
  redirect '/'
end

get '/reset' do
  Spike.instructions = []
  Spike.types = []
  Spike.station_names = []
  redirect '/'
end