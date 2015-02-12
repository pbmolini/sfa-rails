Given(/^I am on "(.+)"$/) do |page_name|
  visit(path_to page_name)
end

When(/^I (visit|go to) (.+)$/) do |_,page_name|
  visit(path_to page_name)
end

When(/^I click on "(.+)"$/) do |link_label|
  click_link link_label
end