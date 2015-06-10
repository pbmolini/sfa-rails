class Picture < ActiveRecord::Base
  belongs_to :boat

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_size :image, less_than: 10.megabytes

  before_destroy :check_pictures_count

  private

  def check_pictures_count
    boat.pictures.count > 1
  end
end
