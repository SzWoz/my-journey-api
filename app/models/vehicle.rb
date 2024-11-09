class Vehicle < ApplicationRecord
  belongs_to :user

  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :year, presence: true
  validates :version, presence: true
  validates :fuel_efficiency, presence: true
end
