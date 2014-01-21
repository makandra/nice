Then /^the screen should be titled "(.*?)"$/ do |title|
  page.should have_css('h1', text: title)
end

Then /^I should see an error message$/ do
  page.should have_css('.formError')
end

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
