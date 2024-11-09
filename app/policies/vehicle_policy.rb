class VehiclePolicy < ApplicationPolicy
  attr_reader :user, :vehicle

  def initialize(user, vehicle)
    @user = user
    @vehicle = vehicle
  end

  def index?
    true
  end

  def show?
    user_owns_vehicle?
  end

  def create?
    true
  end

  def update?
    user_owns_vehicle?
  end

  def destroy?
    user_owns_vehicle?
  end

  private

  def user_owns_vehicle?
    vehicle.user_id == user.id
  end
end

class Scope < Scope
  def resolve
    scope.where(user_id: user.id)
  end
end
