class User < ApplicationRecord
  attachment :profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms

  validates :name, uniqueness: true
  validates :name, presence: true, length: {minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }

  def follow(user_id)
   relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
   relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
   followings.include?(user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  include JpPrefecture
jp_prefecture :prefecture_code

def prefecture_name
  JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)  #都道府県コードから都道府県名に自動で変換する。
end

def prefecture_name=(prefecture_name)
  self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  #~.prefecture_nameで都道府県名を参照出来る様にする。
  #例) @user.prefecture_nameで該当ユーザーの住所(都道府県)を表示出来る。
end

end
