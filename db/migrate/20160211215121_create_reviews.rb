class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :comment
      t.belongs_to :booking
      t.belongs_to :reviewer, index: true
      t.belongs_to :reviewee, index: true

      t.timestamps null: false
    end
  end
end
