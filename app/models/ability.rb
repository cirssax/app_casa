class Ability
  include CanCan::Ability

  def initialize(user)
    user || AdminUser.new
    if user.id_rol == 1 #administrador
      can [:create, :read, :edit, :update], Product
      can [:create, :read, :edit, :update], Type
      can [:create, :read, :edit, :update], User
      can [:create, :read, :edit, :update], Brand
      can [:create, :read, :edit, :update], Request
      can [:create, :read, :edit, :update], Role
      can [:create, :read, :edit, :update], Situation
      can [:create, :read, :edit, :update], State
    elsif user.id_rol == 2 #no administrador
      can [:create, :read, :edit, :update], Product
      can [:create, :read, :edit, :update], Request
      can :read, Type
      can :read, Brand
      can :read, Situation

      cannot [:create, :edit, :update], Type
      cannot [:create, :edit, :update], Brand
      cannot [:create, :edit, :update], Situation
      cannot [:create, :read, :edit, :update], User
      cannot [:create, :read, :edit, :update], State
      cannot [:create, :read, :edit, :update], Role
    else
      cannot [:create, :read, :edit, :update], Product
      cannot [:create, :read, :edit, :update], Type
      cannot [:create, :read, :edit, :update], Brand
      cannot [:create, :read, :edit, :update], Request
      cannot [:create, :read, :edit, :update], Situation
      cannot [:create, :read, :edit, :update], State
      cannot [:create, :read, :edit, :update], Role
      cannot [:create, :read, :edit, :update], User
    end
  end
end
