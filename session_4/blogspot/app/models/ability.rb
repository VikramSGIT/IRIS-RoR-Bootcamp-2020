# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Article
    can :show, Article, public: true

    can [:index, :show, :create], User

    if user.present?
      can :create, Article
      can [:update, :destroy], Article, user_id: user.id

      if user.private_access > 0
        can :show, Article, public: false
      end
      if user.admin
        can :manage, [:User, :Article]
      end
    end
  end
end