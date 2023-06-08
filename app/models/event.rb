class Event < ApplicationRecord
  has_many :reviews
  has_many :bookmarks
  validates :image, presence: true
  validates :category, presence: true
  validates :openings, presence: true
  validates :address, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :tips, presence: true
  validates :link, presence: true
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
