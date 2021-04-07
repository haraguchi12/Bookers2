class User < ApplicationRecord
  attachment :profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy

  validates :name, uniqueness: true
  validates :name, presence: true, length: {minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
end
