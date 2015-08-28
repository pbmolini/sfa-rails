class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    case user
    when AdminUser
      can :manage, :all
    when User

      user ||= User.new # guest user (not logged in)

      if user.admin?
        can :manage, :all
        # da cavare
      else
        alias_action :create, :read, :update, :destroy, :to => :crud

        can [:read, :create], Boat
        can [:crud, :publish], Boat, user_id: user.id

        can [:read, :create], BoatFeaturesSet
        can :crud, BoatFeaturesSet do |bfs|
          bfs.boat.user == user
        end
        can :crud, Picture do |pic|
          pic.boat.user == user
        end

        can :read, Booking, boat: { user_id: user.id }

        can :create, Booking do |booking|
            booking.user == user && booking.boat.user != user
        end
      end
    end

  end
end
