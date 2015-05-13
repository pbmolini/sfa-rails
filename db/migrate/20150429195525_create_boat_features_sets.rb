class CreateBoatFeaturesSets < ActiveRecord::Migration
  def change
    create_table :boat_features_sets do |t|
      t.references :boat, 										index: true
      t.boolean :outboard_engine, 						index: true, default: false
      t.boolean :inboard_engine, 							index: true, default: false
      t.boolean :vhf, 												index: true, default: false
      t.boolean :depth_finder, 								index: true, default: false
      t.boolean	:speed_instrumentation_radar,	index: true, default: false
      t.boolean :sonar, 											index: true, default: false
      t.boolean :autopilot, 									index: true, default: false
      t.boolean :anchor, 											index: true, default: false
      t.boolean :anchor_windlass, 						index: true, default: false
      t.boolean :boarding_ladder, 						index: true, default: false
      t.boolean :shower, 											index: true, default: false
      t.boolean :wc, 													index: true, default: false
      t.boolean :radio_stereo_cd_mp3, 				index: true, default: false
      t.boolean :tv, 													index: true, default: false
      t.boolean :cabin_cruiser_bed, 					index: true, default: false
      t.boolean :galley, 											index: true, default: false
      t.boolean :sink, 												index: true, default: false
      t.boolean :cooler, 											index: true, default: false
      t.boolean :liferaft, 										index: true, default: false
      t.boolean :trolling_motor, 							index: true, default: false
      t.boolean :bimini_top, 									index: true, default: false
      t.boolean :sunbathing_area, 						index: true, default: false
      t.boolean :sport_fishing_equipment, 		index: true, default: false
      t.boolean :safety_equipment, 						index: true, default: false

      t.timestamps null: false
    end
    add_foreign_key :boat_features_sets, :boats
  end
end
