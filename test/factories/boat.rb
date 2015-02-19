FactoryGirl.define do
  factory :boat do
    sequence(:name) { |n| "Test Boat #{n}" }
    manufacturer "Riva"
    daily_price 2500
    year 1968
    model "Aquarama"
    length 8.78
    guest_capacity 40
    boat_category
    pictures { |b| [b.association(:picture)]}
  end
end