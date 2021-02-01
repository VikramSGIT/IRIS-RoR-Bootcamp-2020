# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # All users
    can :index, Article
    
    # Can read public articles
    can :show, Article, public: true

    # Additional permissions for logged in users
    if user.present?
      can [:show, :create], Article
      can [:update, :destroy], Article, user_id: user.id
    end
  end
end