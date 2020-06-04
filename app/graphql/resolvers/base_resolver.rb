module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    protected

    def authorize_user
      return true if context[:current_user].present?

      raise GraphQL::ExecutionError, "User not signed in"
    end

    def authorize_admin
      if context[:current_user].present?
        return true if context[:current_user].has_role?(:admin_reviewer)
        raise GraphQL::ExecutionError, "You are not authorized to access this page."
      else
        raise GraphQL::ExecutionError, "User not signed in."
      end
    end
  end
end