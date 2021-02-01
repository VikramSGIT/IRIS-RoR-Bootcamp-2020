# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Article
    can :create, Article
    can :show, Article

    if user.present?
      can [:show, :create], Article
      can [:update, :destroy], Article, user_id: user.id
      if user.admin
        can :manage, [Atricle, User]
      end
    end
  end
end