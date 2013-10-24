require_relative 'lib/simple_predictor'
require_relative 'lib/complex_predictor'

def run!(predictor_klass)
  puts "+----------------------------------------------------+"
  puts "| #{predictor_klass}#{" " * (51 - predictor_klass.to_s.size)}|"
  puts "+----------------------------------------------------+"
  puts "Loading books..."
  start_time = Time.now
  predictor = predictor_klass.new()
  puts "Loading books took #{Time.now - start_time} seconds."


  puts "Training..."
  start_time = Time.now
  predictor.train!
  puts "Training took #{Time.now - start_time} seconds."

  accuracy = predictor.predict_test_set
  puts "Accuracy: #{accuracy}"
end

run!(SimplePredictor)
run!(ComplexPredictor)
