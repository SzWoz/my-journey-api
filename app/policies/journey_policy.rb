class JourneyPolicy < ApplicationPolicy
  attr_reader :user, :journey

  def initialize(user, journey)
    @user = user
    @journey = journey
  end

  def index?
    true
  end

  def show?
    user_owns_journey?
  end

  def create?
    true
  end

  def update?
    user_owns_journey?
  end

  private

  def user_owns_journey?
    journey.user_id == user.id
  end
end
