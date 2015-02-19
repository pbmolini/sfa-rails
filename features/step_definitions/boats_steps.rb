Given(/^These boats are registered on SfA: (.+)$/) do |boats|
  boats.split(', ').each do |boat|
    # TODO use factory girl
    FactoryGirl.create(:boat, name: boat)
  end
end

Given(/^All boats are available$/) do
  # TODO this will obviously use some search
  @available_boats = Boat.all
end

Then(/^I should see "(.+)" in "(.+)"$/) do |boat_name, page_name|
  visit(path_to page_name)
  expect(page).to have_content boat_name
end

When(/^I click on a boat$/) do
  @boat = Boat.all.sample
  click_link @boat.name
end

Then(/^I should see all the details of the selected boat$/) do
  # TODO refactor including CSS selectors
  expect(page).to have_content @boat.name
  expect(page).to have_content @boat.manufacturer
  expect(page).to have_content @boat.daily_price
  expect(page).to have_content @boat.year
  expect(page).to have_content @boat.model
  expect(page).to have_content @boat.length
  expect(page).to have_content @boat.guest_capacity
  expect(page).to have_content @boat.boat_category
end

Given(/^I own a boat called "(.+)"$/) do |boat_name|
  @boat_attrs = FactoryGirl.attributes_for(:boat, name: boat_name)
end

When(/^I add the details of my boat$/) do
  within('form') do
    @boat_attrs.each do |att, value|
      case att
      when :year
        select value, from: att.to_s.humanize
      when :pictures
        # yeah... that's lame
        attach_file('Image', "#{Rails.root}/test/fixtures/files/ship.jpg")
      else
        fill_in att.to_s.humanize, with: value
      end
    end

    click_button 'Create Boat'
  end
end