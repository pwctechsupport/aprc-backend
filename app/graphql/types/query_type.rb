module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :me, Types::UserType, null: true do 
      description 'Returns the current user'
    end
    
    def me(demo: false)
      context[:current_user]
    end

    field :users, resolver: Resolvers::QueryType::UsersResolver
    field :policies, resolver: Resolvers::QueryType::PoliciesResolver
    field :policy_categories, resolver: Resolvers::QueryType::PolicyCategoriesResolver
  end
end
