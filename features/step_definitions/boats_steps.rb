Given(/^These boats are registered on SfA: (.+)$/) do |boats|
  boat_cat = BoatCategory.find_or_create_by(name: 'Gran vascello')

  boats.split(', ').each do |boat|
    # TODO use factory girl
    Boat.create!(name: boat, manufacturer: 'Some manufacturer', daily_price: 250, year: 2001, model: 'Caravella', length: 45, guest_capacity: 40, boat_category: boat_cat)
  end
end

Given(/^All boats are available$/) do
  # TODO this will obviously use some search
  @available_boats = Boat.all
end

Then(/^I should see "(.+)"$/) do |boat_name|
  page.has_content? boat_name
end

When(/^I click on a boat$/) do
  @boat = Boat.all.sample
  click_link @boat.name
end

Then(/^I should see all the details of the selected boat$/) do
  # TODO refactor including CSS selectors
  page.has_content?(@boat.name) &&
  page.has_content?(@boat.manufacturer) &&
  page.has_content?(@boat.daily_price) &&
  page.has_content?(@boat.year) &&
  page.has_content?(@boat.model) &&
  page.has_content?(@boat.length) &&
  page.has_content?(@boat.guest_capacity) &&
  page.has_content?(@boat.boat_category)
end

Given(/^I own a boat called "(.+)"$/) do |boat_name|
  @boat_attrs = FactoryGirl.attributes_for(:boat, name: boat_name)
end

When(/^I add the details of my boat$/) do
  within('form') do
    @boat_attrs.each do |att, value|
      fill_in att.to_s.humanize, with: value
    end

    click_button 'Create Boat'
  end
end

Then(/^I should see my boat in the list of boats$/) do
  visit(boats_path)
  page.has_content? @boat_attrs[:name]
end