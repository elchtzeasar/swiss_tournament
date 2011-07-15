class Player < ActiveRecord::Base
  has_many :participations
  has_many :tournaments, :through => 'participations'
  has_many :matches, :through => 'tournaments'
  validates_uniqueness_of :name
end
