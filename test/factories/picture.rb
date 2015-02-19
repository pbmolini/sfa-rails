include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :picture do
    image { fixture_file_upload("#{Rails.root}/test/fixtures/files/ship.jpg", 'image/jpg') }
  end
end