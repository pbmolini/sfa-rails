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

      can :my_boats, Boat, user_id: user.id

      can [:read, :create], BoatFeaturesSet

      can :crud, BoatFeaturesSet do |bfs|
        bfs.boat.user == user
      end

      can :crud, Picture do |pic|
        pic.boat.user == user
      end

      can :my_bookings, Booking, user_id: user.id

      # Ability for :show and :index. Do not change the order!
      # The user is the booking's creator...
      can :read, Booking, user_id: user.id
      # ... nobody can see the list of bookings (since they belong to a boat)...
      cannot :index, Booking
      # ... apart from the boat's owner
      can :read, Booking, boat: { user_id: user.id }
      # can :read, Booking do |booking|
      #   booking.user == user or booking.boat.user == user
      # end


      # if is complete and the booking's creator is not the boat's owner
      can :create, Booking do |booking|
        user.complete? and
        booking.boat.complete? and
        booking.user == user and 
        booking.boat.user != user
      end

      # if the booking is pending and the user is the boat's owner
      can [:reject, :accept], Booking do |booking|
        booking.pending? and booking.boat.user == user
      end

      # if can read, the booking may be canceled (managed by aasm), and it is not expired
      can :cancel, Booking do |booking|
        (booking.user == user or booking.boat.user == user) and 
        booking.may_cancel? and
        !booking.has_expired?
      end

      # if can read and the booking is not canceled (managed by aasm)
      can :reply, Booking do |booking|
        (booking.user == user or booking.boat.user == user) and not booking.canceled?
      end

      can [:read, :create, :destroy], Day, boat: { user_id: user.id }

      # if the booking is :accepted, has expired, 
      # current_user is the booking's guest or host and
      # has not yet reviewed the booking
      can :create, Review do |review|
        booking = review.booking
        already_reviewed = false
        if booking.guest_review.present? 
          if booking.guest_review.reviewer == user
            already_reviewed = true
          end
        end
        if booking.host_review.present? 
          if booking.host_review.reviewer == user
            already_reviewed = true
          end
        end

        review.booking.accepted? and review.booking.has_expired? and 
        (review.booking.user == user or review.booking.boat.user == user) and
        !already_reviewed
      end


      # if is the associated booking's guest or host
      can :index, Review do |review|
        review.booking.user == user or review.booking.boat.user == user
      end
    end

  end
end
