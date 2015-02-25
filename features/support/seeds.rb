BoatCategory.find_or_create_by(name: 'Motoscafo')

#3.times { FactoryGirl.create(:boat) }