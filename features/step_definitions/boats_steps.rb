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

Given(/^There is a boat with:$/) do |table|
  @boat = FactoryGirl.create(:boat, table.rows_hash)
end

Given(/^the boat is already booked$/) do |table|
  booking = Booking.new(table.rows_hash.inject({}) {|h, (k,v)| h[k] = eval(v); h })
  booking.boat = @boat
  booking.save
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

    select BoatCategory.first.name, from: 'Boat category'

    click_button 'Create Boat'
    #byebug
  end
end

When(/^I fill in the period I am interested in as follows:$/) do |table|
  @booking_attrs = table.rows_hash
  within('form.new_booking') do
    @booking_attrs.each do |key, value|
      if ['start_time','end_time'].include? key
        select_date_and_time eval(value), from: "booking_#{key}"
      else
        fill_in key.humanize, with: eval(value)
      end
    end
  end
end

Then(/^There should be a booking for the specified dates$/) do
  booking = Booking.last
  expect(booking.start_time).to eq(eval(@booking_attrs[:start_time]).beginning_of_minute)
  expect(booking.end_time).to eq(eval(@booking_attrs[:end_time]).beginning_of_minute)
  expect(booking.people_on_board).to eq(@booking_attrs[:people_on_board].to_i)
end

Then(/^I should be notified the boat is unavailable$/) do
  expect(page).to have_content "This boat is not available in the period you selected"
end