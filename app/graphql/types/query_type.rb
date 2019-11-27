module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :me, Types::UserType, null: true do 
      description 'Returns the current user'
    end

    field :res, [Types::ResourceType], null: true do
      description 'Returns Resources Attributes'
    end
    
    field :bus, [Types::BusinessProcessType], null: true do
      description 'Returns Business Processes Attributes'
    end
    
    field :it, [Types::ItSystemType], null: true do
      description 'Returns IT Systems Attributes'
    end

    def me(demo: false)
      context[:current_user]
    end

    def res(demo: false)
      Resource.all
    end

    def bus(demo: false)
      BusinessProcess.all
    end

    def it(demo:false)
      ItSystem.all
    end

    field :users, resolver: Resolvers::QueryType::UsersResolver
    field :policies, resolver: Resolvers::QueryType::PoliciesResolver
    field :policy_categories, resolver: Resolvers::QueryType::PolicyCategoriesResolver
    field :resources, resolver: Resolvers::QueryType::ResourcesResolver
    field :it_systems, resolver: Resolvers::QueryType::ItSystemsResolver
    field :business_processes, resolver: Resolvers::QueryType::BusinessProcessesResolver



  end
end