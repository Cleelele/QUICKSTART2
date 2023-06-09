class BookmarkPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    return true
  end

  def new?
    return create?
  end

  def create?
    return true
  end


  def destroy?
    return true
  end
end
