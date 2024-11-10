class Vehicle < ApplicationRecord
  FUEL_TYPE = %w[95 98 diesel].freeze

  belongs_to :user

  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :year, presence: true
  validates :version, presence: true
  validates :fuel_efficiency, presence: true
  validates :fuel_type, presence: true, inclusion: { in: FUEL_TYPE }
end
