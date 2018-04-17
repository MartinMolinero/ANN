class Perceptron
  def initialize(d, learning)
    @input_size = d
    @weights = []
    @output = nil
    @learning_rate = learning.to_f
    first_weights(d)
  end

  def input_size
    @input_size
  end

  def weights
    @weights
  end

  def output
    @output
  end

  def learning_rate
    @learning_rate
  end

  def first_weights(d)
    for i in 0..d
      @weights.push(rand)
    end
    #puts self.inspect
  end

  def train(hash, limit)
    step = 0
    while step < limit do
      error = 0
      step += 1
      hash.each do |key, value|
        expected_output = value.to_i
        #puts "\nexpected_output #{expected_output}"
        inm = key
        output = get_output(inm, @weights)

        #puts "output #{output}"
        #puts "error #{error}"
        error += (expected_output - output).abs
        #puts "change_weights #{inm}"
        @weights = change_weights(inm, expected_output, output)
      end
      if error == 0
        return @weights
      end
    end
  end

  def change_weights(inputs, expected_output, actual_output)
    @weights.each_with_index do |w, i|
      #puts "old weight #{@weights[i]} + #{@learning_rate} * (#{expected_output} - #{actual_output}) * #{inputs[i].to_f}"
      @weights[i] = @weights[i] + @learning_rate * (expected_output - actual_output) * inputs[i].to_f
      #puts "new weight #{@weights[i]}"
    end
    return @weights
  end

  def evaluate(test_samples)
    #puts "samples #{test_samples}"
    test_samples.each do |t|
      t = t.split(',')
      t.unshift(1)
      #puts t
      temp_out = get_output(t, @weights)
      puts temp_out
    end
  end

  def get_output(inputs, weights)
    output = 0
    inputs.each_with_index do |input, i|
      #puts "input #{input} weights #{weights[i]} i #{i}"
      output += input.to_f * weights[i]
    end
    #puts "output #{output}"
    if output <= 0
      output =  0
    else
      output = 1
    end
    #puts "after activation function #{output}"
    output
  end

end

#refactored
def get_samples(input, first, n_m)
  start = first
  last = start + n_m
  set = []
  while start < last do
    input[start] = input[start].chomp
    set.push(input[start])
    start =  start + 1
  end
  [set, start]
end

=begin
# just in case i need to change something in the future
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
=end

def row_to_inputs_out(set, d)
  @input_output = Hash.new
  set.each do |row|
    a = row.gsub(' ','').split(',')
    inp = []
    inp.push(1)
    for i in 0..d-1
      inp.push(a[i])
    end
    #puts "inp #{inp}"
    out = a.last
    #puts "out #{out}"
    h2 = {inp => out}
    @input_output.merge!(h2)
  end
  @input_output
  #puts @input_output.inspect
end

input = $stdin.readlines

d = input[0].to_i
m = input[1].to_i
n = input[2].to_i
training_samples =  get_samples(input, 3 ,m)[0]
last = get_samples(input, 3 ,m)[1]
hash_in_out = row_to_inputs_out(training_samples, d)
p = Perceptron.new(d, 0.01)
temp_w = p.train(hash_in_out, 10)
#puts "test"
test_samples =  get_samples(input, last, n)[0]
#puts "temp_w #{temp_w.nil?}"
if temp_w

  p.evaluate(test_samples)
else
  puts "no solution found"
end
