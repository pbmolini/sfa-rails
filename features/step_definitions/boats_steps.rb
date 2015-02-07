Given(/^These boats are registered on SfA: (.+)$/) do |boats|
  boat_cat = BoatCategory.find_or_create_by(name: 'Gran vascello')

  boats.split(', ').each do |boat|
    # TODO use factory girl
    Boat.create!(name: boat, manufacturer: 'Some manufacturer', daily_price: 250, year: 2001, model: 'Caravella', length: 45, guest_capacity: 40, boat_category: boat_cat)
  end
end

Then(/^I should see (.+)$/) do |boat_name|
  page.has_content? boat_name
end