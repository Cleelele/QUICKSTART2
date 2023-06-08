class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :bookmarks
  has_many :reviews
  has_many :messages, through: :chatrooms
  has_one :questionnaire
  validates :nickname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true, length: { minimum: 6 }
  validates :presonality_type, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         has_one :personality
end
