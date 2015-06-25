class Day < ActiveRecord::Base
  belongs_to :boat
  belongs_to :booking
end
