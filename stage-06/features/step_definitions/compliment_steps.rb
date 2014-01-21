Given /^my random generator is predictable$/ do
  # Initialize the random generator with a fixed seed.
  # This way we will get a predictable series of random values
  # for this process.
  Compliment.random_generator = Random.new(239842439)
end
