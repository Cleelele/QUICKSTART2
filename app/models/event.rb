class Event < ApplicationRecord
  has_many :reviews
  has_many :bookmarks
  validates :image, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :description, presence: true
  validates :price, presence: true
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
