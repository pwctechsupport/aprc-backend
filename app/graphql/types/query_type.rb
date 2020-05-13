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

    field :notification, Types::NotificationType, null: true do
      argument :id, ID, required: true
      description 'Returns the notification of an object'
    end

    field :file_attachment, Types::FileAttachmentType, null: true do
      argument :id, ID, required: true
      description 'Returns the File Attachment of an Object'
    end 

    field :activity_control, Types::ActivityControlType, null: true do
      argument :id, ID, required: true
      description 'Returns the Activity Control and its Guidance of an Object'
    end

    field :manual, Types::ManualType, null: true do
      argument :id, ID, required: true
      description 'Returns the User Manuals'
    end

    field :department, Types::DepartmentType, null: true do
      argument :id, ID, required: true
      description 'Returns the User Department'
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
    
    field :bookmark, Types::BookmarkType, null: true do
      argument :id, ID, required: true
      description 'Returns Bookmark Originator Based By ID'
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
    
    field :request_edit, Types::RequestEditType, null: true do 
      argument :id, ID, required: true
      description 'Returns the Current Edit Request'
    end

    field :tag, Types::TagType, null: true do
      argument :id, ID, required: true
      description 'Returns the Current image tag location'
    end

    field :enum_list, Types::EnumListType, null: true do
      argument :id, ID, required: true
      description 'Returns the current Enumerated List'
    end


    def me(demo: false)
      context[:current_user]
    end

    def version(demo: false)
      peng = context[:current_user]
      pengguna = PaperTrail::Version.where(whodunnit: peng.id)
      pengguna
    end

    def notification(id:)
      Notification.find_by(id:id)
    end

    def department(id:)
      Department.find_by(id:id)
    end

    def request_edit(id:)
      RequestEdit.find_by(id:id)
    end

    def file_attachment(id:)
      FileAttachment.find_by(id:id)
    end

    def activity_control(id:)
      ActivityControl.find_by(id:id)  
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

    def bookmark(id:)
      current_user = context[:current_user]
      bookmark_query = current_user.bookmark.find_by(id:id)
    end

    def policy(id:)
      pol = Policy&.find_by(id:id)
      pol&.update(recent_visit: Time.now)
      pol
    end

    def risk(id:)
      Risk.find_by(id:id)
    end

    def policy_category(id:)
      PolicyCategory.find_by(id:id)
    end

    def resource(id:)
      res = Resource&.find_by(id:id)
      res&.update(recent_visit: Time.now)
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

    def tag(id:)
      Tag.find_by(id:id)
    end

    def enum_list(id:)
      EnumList.find_by(id:id)
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
    field :bookmarks, resolver: Resolvers::QueryType::BookmarksResolver
    field :versions, resolver: Resolvers::QueryType::VersionsResolver
    field :roles, resolver: Resolvers::QueryType::RolesResolver
    field :notifications, resolver: Resolvers::QueryType::NotificationsResolver
    field :request_edits, resolver: Resolvers::QueryType::RequestEditsResolver
    field :file_attachments, resolver: Resolvers::QueryType::FileAttachmentsResolver
    field :activity_controls, resolver: Resolvers::QueryType::ActivityControlsResolver
    field :tags, resolver: Resolvers::QueryType::TagsResolver
    field :enum_lists, resolver: Resolvers::QueryType::EnumListsResolver
    field :recently_added_policies, resolver: Resolvers::QueryType::RecentlyAddedPoliciesResolver
    field :popular_policies, resolver: Resolvers::QueryType::PopularPoliciesResolver
    field :recently_visited_policies, resolver: Resolvers::QueryType::RecentlyVisitedPoliciesResolver
    field :popular_resources, resolver: Resolvers::QueryType::PopularResourcesResolver
    field :recent_resources, resolver: Resolvers::QueryType::RecentResourcesResolver
    field :manuals, resolver: Resolvers::QueryType::ManualsResolver
    field :sidebar_policies, resolver: Resolvers::QueryType::SidebarPoliciesResolver
    field :departments, resolver: Resolvers::QueryType::DepartmentsResolver
    field :user_policies, resolver: Resolvers::QueryType::UserPoliciesResolver
    field :preparer_policies, resolver: Resolvers::QueryType::PreparerPoliciesResolver
    field :reviewer_policies, resolver: Resolvers::QueryType::ReviewerPoliciesResolver
  end
end