Given /^my random generator is predictable$/ do
  # Initialize the random generator with a fixed seed.
  # This way we will get a predictable series of random values
  # for this process.
  Compliment.random_generator = Random.new(239842439)
end

Then /^the screen should be titled "(.*?)"$/ do |title|
  page.should have_css('h1', text: title)
end

Then /^I should see an error message$/ do
  page.should have_css('.formError')
end

#AfterStep('@slow') do
#  15.times { sleep 0.1 }
#end



Before('@slow') do
  @slow = true
end

After('@slow') do
  @slow = false
  sleep 1.5
end

Transform /.*/ do |match|
  if @slow
    sleep 1.5
  end
  match
end
