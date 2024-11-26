class Post < ApplicationRecord
  # Validations
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :description, presence: true, length: { maximum: 250 }
  validates :keyword, presence: true, length: { maximum: 100 }
  validates :user, presence: true
  #validates :content, presence: true

  # Active Storage associations
  has_many_attached :images  # For multiple image attachments
  has_one_attached :image    # For a single image attachment

  # Custom validation for images
  validate :validate_images
  validate :validate_image_type

  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Callbacks
  before_create :randomize_id

  private

  # Generate a random ID
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while Post.exists?(id: self.id)
  end

  # Validate image upload limit
  def validate_images
    if images.attached? && images.length > 5
      errors.add(:images, "cannot have more than 5 images")
    end
  end

  # Validate allowed image types
  def validate_image_type
    if images.attached?
      images.each do |image|
        unless image.content_type.in?(%w[image/png image/jpg image/jpeg])
          errors.add(:images, "must be a PNG, JPG, or JPEG")
        end
      end
    end
  end
end
