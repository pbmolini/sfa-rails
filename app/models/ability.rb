class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    case user
    when AdminUser
      can :manage, :all

    else # User or Guest
      user ||= User.new # guest user (not logged in)

      alias_action :create, :read, :update, :destroy, :to => :crud

      # Any registered user
      can :create, Boat

      # If either the boat is ready for publication or the user is the boat's owner
      can :read, Boat do |boat|
        boat.can_be_published? or boat.user == user
      end
      can [:crud, :publish], Boat, user_id: user.id

      can [:read, :create], BoatFeaturesSet
      can :crud, BoatFeaturesSet do |bfs|
        bfs.boat.user == user
      end
      can :crud, Picture do |pic|
        pic.boat.user == user
      end

      # if the user is either the booking's creator or the boat's owner
      can :read, Booking do |booking|
        booking.user == user or booking.boat.user == user
      end

      # if the booking's creator is not the boat's owner
      can :create, Booking do |booking|
        booking.user == user and booking.boat.user != user
      end

      # if the booking is pending and the user is the boat's owner
      can [:reject, :accept], Booking do |booking|
        booking.pending? and booking.boat.user == user
      end

      # if can read and the booking may be canceled (managed by aasm)
      can :cancel, Booking do |booking|
        (booking.user == user or booking.boat.user == user) and booking.may_cancel?
      end

      # if can read and the booking is not canceled (managed by aasm)
      can :reply, Booking do |booking|
        (booking.user == user or booking.boat.user == user) and not booking.canceled?
      end

      can [:read, :create, :destroy], Day, boat: { user_id: user.id }

    end

  end
end
