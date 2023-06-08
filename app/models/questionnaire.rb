class Questionnaire < ApplicationRecord
  belongs_to :user
  validates :questions, presence: true
  validates :results, presence: true
end
