class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :likes

  # Callbacks
  before_create :randomize_id

  private

  # Generate a random ID
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while User.exists?(id: self.id)
  end
end
