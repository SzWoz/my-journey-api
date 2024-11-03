class Vehicle < ApplicationRecord
  validates :make, presence: true
  validates :model, presence: true
  validates :year, presence: true
  validates :fuel_efficiency, presence: true
end
