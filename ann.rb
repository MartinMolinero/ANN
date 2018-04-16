class Perceptron
  def initialize(d, learning)
    @input_size = d
    @weights = []
    @output = nil
    @learning_rate = learning
    first_weights(d)
  end

  def first_weights(d)
    for i in 0..d
      @weights.push(Math.random)
    end
  end

  def calculate_output(inputs, weights)
    @output = 0
    inputs.each_with_index do |input, i|
      @output += input * weights[i]
    end
    if output <= 0
      @output =  0
    else
      @output = 1
    end
  end

end


def get_training_examples(input,m)
  start = 3
  last = start + m
  training = []
  while start < last do
    input[start] = input[start].chomp
    training.push(input[start])
    start =  start + 1
  end
  [training,start]
end

def get_test_examples(input, last, n)
  start = last
  ending =start + n
  tests = []
  while start < ending do
    input[start] = input[start].chomp
    tests.push(input[start])
    start =  start + 1
  end
  tests
end


def row_to_inputs_out(set, d)
  @input_output = Hash.new
  set.each do |row|
    a = row.gsub(' ','').split(',')
    inp = []
    for i in 0..d-1
      inp.push(a[i])
      #puts "inp #{inp}"
    end
    out = a.last
    #puts "out #{out}"
    h2 = {inp => out}
    @input_output.merge!(h2)
  end
  @input_output
  puts @input_output.inspect
end

input = $stdin.readlines

d = input[0].to_i
m = input[1].to_i
n = input[2].to_i
training_samples =  get_training_examples(input, m)[0]
puts training_samples
last = get_training_examples(input, m)[1] -1
hash_in_out = row_to_inputs_out(training_samples, d)
puts "test"
test_samples =  get_test_examples(input, last, n)
