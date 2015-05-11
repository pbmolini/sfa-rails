class BoatFeaturesSet < ActiveRecord::Base
  belongs_to :boat
  
  validates_with EngineValidator

  FEATURES = [
  	:outboard_engine,
    :inboard_engine,
    :depth_finder,
    :vhf,
    :speed_instrumentation_radar,
    :sonar,
    :autopilot,
    :anchor,
    :anchor_windlass,
    :boarding_ladder,
    :shower,
    :wc,
    :radio_stereo_cd_mp3,
    :tv,
    :cabin_cruiser_bed,
    :galley,
    :sink,
    :cooler,
    :liferaft,
    :trolling_motor,
    :bimini_top,
    :sunbathing_area,
    :sport_fishing_equipment,
    :safety_equipment
   ].freeze
end
