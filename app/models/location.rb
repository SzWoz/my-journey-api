class Location < ApplicationRecord
  belongs_to :journey
  has_many :passengers, dependent: :destroy
end
