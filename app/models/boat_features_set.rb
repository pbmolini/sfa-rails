class BoatFeaturesSet < ActiveRecord::Base
  belongs_to :boat
  validates_with EngineValidator
end
