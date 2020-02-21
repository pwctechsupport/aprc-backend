module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :firstName, String, null: true
    field :lastName, String, null: true
    field :email, String, null: true
    field :token, String, null: false
    field :phone, String, null: true
    field :role, [Int], null: true
    field :department, String, null: true
    field :jobPosition, String, null: true
    field :policies, [Types::PolicyType], null: true
    field :policy_categories, [Types::PolicyCategoryType], null: true 
    field :created_at, String, null: true
    field :updated_at, String, null: true
    field :bookmark_policies_user, [Types::BookmarkPolicyType], null: true
    field :resource_ratings, [Types::ResourceRatingType], null: true
    field :risks, [Types::RiskType], null: true
    field :bookmark_risks_user, [Types::BookmarkRiskType], null: true
    field :controls, [Types::ControlType], null: true
    field :bookmark_controls_user, [Types::BookmarkControlType], null: true
    field :roles, [Types::RoleType], null: true
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    field :has_edit_access, Boolean, null: true
    field :request_status, String, null: true
    field :request_edits, [Types::RequestEditType], null: true
    field :request_edit, Types::RequestEditType, null: true
    field :file_attachments, [Types::FileAttachmentType], null: true
    field :activity_controls, [Types::ActivityControlType], null: true

    def activity_controls
      if object&.class == Hash
        empty = []
      else
        object&.activity_controls
      end 
    end

    def file_attachments
      if object&.class == Hash
        empty = []
      else
        object&.file_attachments
      end  
    end

    def request_edit
      object&.request_edit
    end

    def has_edit_access
      current_user = context[:current_user]
      if object.class == Hash
        empty = [] 
      else
        object&.request_edits&.where(user_id: current_user&.id)&.last&.state == "approved"
      end
    end

    def request_status
      current_user = context[:current_user]
      if object.class == Hash
        empty = []
      else
        object&.request_edits&.where(user_id: current_user&.id)&.last&.state
      end
    end

    # field :controls, [Types::ControlType], null: true
    # field :risks, [Types::RiskType], null: true
    # field :references, [Types::ReferenceType], null: true
    # field :business_processes, [Types::BusinessProcessType], null: true
    # field :resources, [Types::ResourceType], null: true
    def bookmark_policies_user
      bookmark = object.bookmark_policies
    end

    def bookmark_risks_user
      bookmark = object.bookmark_risks
    end

    def bookmark_controls_user
      bookmark = object.bookmark_controls
    end

    def policies
      current_user = context[:current_user]
      current_user&.policies
    end


    field :policy, Types::PolicyType, null: true do
      argument :id, ID, required: true
    end
    
    def policy(id:)
      current_user =context[:current_user]
      current_user&.policies&.find_by(id:id)
    end

  end
end