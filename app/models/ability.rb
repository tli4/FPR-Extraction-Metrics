class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
      can :read, :all
      can :write, :all
    elsif user.has_role? :readWrite
      can :read, :all
      can :write, :all
    elsif user.has_role? :readOnly
      can :read, :all
    end
  end
end
