module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :me, Types::UserType, null: true do 
      description 'Returns the current user'
    end

    field :version, [Types::VersionType], null: true do 
      description 'Returns the Version of an Object'
    end

    # field :res, [Types::ResourceType], null: true do
    #   description 'Returns Resources Attributes'
    # end
    
    # field :bus, [Types::BusinessProcessType], null: true do
    #   description 'Returns Business Processes Attributes'
    # end
    
    # field :it, [Types::ItSystemType], null: true do
    #   description 'Returns IT Systems Attributes'
    # end

    # field :ref, [Types::ReferenceType], null: true do
    #   description 'Returns References from SubPolicy'
    # end

    # field :control, [Types::ControlType], null: true do
    #   description 'Returns Master Control Data '
    # end

    field :policy, Types::PolicyType, null: true do
      argument :id, ID, required: true
      argument :undelete, Types::Enums::RevertConfirmation, required: false
      description 'Returns Policy By ID'
    end

    field :policy_category, Types::PolicyCategoryType, null: true do
      argument :id, ID, required: true
      description 'Returns Policy Category By ID'
    end

    field :resource, Types::ResourceType, null: true do
      argument :id, ID, required: true
      description 'Returns Resource By ID'
    end

    field :user, Types::UserType, null: true do
      argument :id, ID, required: true
      description 'Returns User By ID'
    end

    field :reference, Types::ReferenceType, null: true do
      argument :id, ID, required: true
      description 'Returns Reference By ID'
    end

    field :business_process, Types::BusinessProcessType, null: true do
      argument :id, ID, required: true
      description 'Returns Business Process By ID'
    end

    field :it_system, Types::ItSystemType, null: true do
      argument :id, ID, required: true
      description 'Returns IT System By ID'
    end

    field :control, Types::ControlType, null: true do
      argument :id, ID, required: true
      description 'Returns Control By ID'
    end

    field :description, Types::DescriptionType, null: true do
      argument :id, ID, required: true
      description 'Returns Description By ID'
    end

    field :risk, Types::RiskType, null: true do
      argument :id, ID, required: true
      description 'Returns Risk By ID'
    end

    field :resource_rating, Types::ResourceRatingType, null: true do
      argument :id, ID, required: true
      description 'Returns the Current Resource Rating and Rating Calculation'
    end
    


    def me(demo: false)
      context[:current_user]
    end

    def version(demo: false)
      peng = context[:current_user]
      pengguna = PaperTrail::Version.where(whodunnit: peng.id)
      pengguna
    end

    # def res(demo: false)
    #   Resource.all
    # end

    # def bus(demo: false)
    #   BusinessProcess.all
    # end

    # def it(demo:false)
    #   ItSystem.all
    # end

    # def ref(demo:false)
    #   Reference.all
    # end

    # def control(demo: false)
    #   Control.all
    # end

    def policy(id:)
      pol = Policy.find_by(id:id)
      vieu = pol.visit+1
      pol.update(visit: vieu)
      pol
    end

    def risk(id:)
      Risk.find_by(id:id)
    end

    def policy_category(id:)
      PolicyCategory.find_by(id:id)
    end

    def resource(id:)
      res = Resource.find_by(id:id)
      view = res.visit+1
      res.update(visit: view)
      res
    end

    def control(id:)
      Control.find_by(id:id)
    end

    def it_system(id:)
      ItSystem.find_by(id:id)
    end

    def business_process(id:)
      BusinessProcess.find_by(id:id)
    end

    def description(id:)
      Description.find_by(id:id)
    end

    def reference(id:)
      Reference.find_by(id:id)
    end

    def user(id:)
      User.find_by(id:id)
    end

    def resource_rating(id:)
      ResourceRating.find_by(id:id)
    end


    field :users, resolver: Resolvers::QueryType::UsersResolver
    field :policies, resolver: Resolvers::QueryType::PoliciesResolver
    field :policy_categories, resolver: Resolvers::QueryType::PolicyCategoriesResolver
    field :resources, resolver: Resolvers::QueryType::ResourcesResolver
    field :it_systems, resolver: Resolvers::QueryType::ItSystemsResolver
    field :business_processes, resolver: Resolvers::QueryType::BusinessProcessesResolver
    field :references, resolver: Resolvers::QueryType::ReferencesResolver
    field :controls, resolver: Resolvers::QueryType::ControlsResolver
    field :risks, resolver: Resolvers::QueryType::RisksResolver
    field :resource_ratings, resolver: Resolvers::QueryType::ResourceRatingsResolver
    field :bookmark_policies, resolver: Resolvers::QueryType::BookmarkPoliciesResolver
    field :bookmark_risks, resolver: Resolvers::QueryType::BookmarkRisksResolver
    field :bookmark_controls, resolver: Resolvers::QueryType::BookmarkControlsResolver
    field :bookmark_business_processes, resolver: Resolvers::QueryType::BookmarkBusinessProcessesResolver
    field :versions, resolver: Resolvers::QueryType::VersionsResolver
    field :roles, resolver: Resolvers::QueryType::RolesResolver
  end
end