class League < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :league_members
  has_many :users, through: :league_members
  has_many :matches
  has_many :rankings
  has_many :ratings

  scope :matches, -> { includes(:users) }

  validates :name, presence: true, length: { in: 3..30 }, uniqueness: true
  validates :description, presence: true, length: { in: 5..150 }
end
