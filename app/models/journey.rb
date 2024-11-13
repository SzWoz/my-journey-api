class Journey < ApplicationRecord
  has_many :locations, dependent: :destroy
  belongs_to :user
  belongs_to :vehicle
end
