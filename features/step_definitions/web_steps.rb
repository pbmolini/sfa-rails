Given(/^I am on "(.+)"$/) do |page_name|
  visit(path_to page_name)
end

When(/^I (visit|go to) (.+)$/) do |_,page_name|
  visit(path_to page_name)
end

When(/^I click on "(.+)"$/) do |link_label|
  click_link link_label
end

When(/^I click on the "(.+)" button$/) do |button_label|
  click_button button_label
end

Then(/^I should see: (.+)$/) do |stuff|
  stuff.split(', ').each do |thing|
    expect(page).to have_content thing
  end
end