Given /^my random generator is predictable$/ do
  # Initialize the random generator with a fixed seed.
  # This way we will get a predictable series of random values
  # for this process.
  Kernel.srand(239842439)
end

Then /^the screen should be titled "(.*?)"$/ do |title|
  page.should have_css('h1', text: title)
end

Then /^I should see an error message$/ do
  page.should have_css('.formError')
end

AfterStep('@slow') do
  sleep 1.5
end
