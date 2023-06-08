class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :bookmarks
  has_many :reviews
  has_many :messages, through: :chatrooms
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :personality
end
