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
  end

  def train(hash, limit)
    step = 0
    while step < limit do
      error = 0
      hash.each do |key, value|
        expected_output = value.to_i
        inm = key
        output = get_output(inm, @weights)
        error += (expected_output - output).abs
        @weights = change_weights(inm, expected_output, output)
      end
      step += 1
      if error == 0
        return @weights
      end
    end
  end

  def change_weights(inputs, expected_output, actual_output)
    @weights.each_with_index do |w, i|
      @weights[i] = @weights[i] + @learning_rate * (expected_output - actual_output) * inputs[i].to_f
    end
    return @weights
  end

  def evaluate(test_samples)
    test_samples.each do |t|
      t = t.split(',')
      #this is what i was missing
      t.unshift(1)
      temp_out = get_output(t, @weights)
      puts temp_out
    end
  end

  def activation(evaluation, treshold)
    val = 0
    if evaluation <= treshold
      val = 0
    else
      val = 1
    end
    val
  end

  def get_output(inputs, weights)
    output = 0
    inputs.each_with_index do |input, i|
      output += input.to_f * weights[i]
    end
    output = activation(output, 0)
    output
  end

end

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

def row_to_inputs_out(set, d)
  @input_output = Hash.new
  set.each do |row|
    a = row.gsub(' ','').split(',')
    inp = []
    inp.push(1)
    for i in 0..d-1
      inp.push(a[i])
    end
    out = a.last
    h2 = {inp => out}
    @input_output.merge!(h2)
  end
  @input_output
end

input = $stdin.readlines

d = input[0].to_i
m = input[1].to_i
n = input[2].to_i
training_samples =  get_samples(input, 3 ,m)[0]
last = get_samples(input, 3 ,m)[1]
hash_in_out = row_to_inputs_out(training_samples, d)
p = Perceptron.new(d, 0.03)
test_samples = get_samples(input, last, n)[0]
temp_w = p.train(hash_in_out, 2000)
if temp_w
  p.evaluate(test_samples)
else
  puts "no solution found"
end
