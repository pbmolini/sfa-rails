When(/^I (visit|go to) (.+)$/) do |_,page_name|
  visit(path_to page_name)
end