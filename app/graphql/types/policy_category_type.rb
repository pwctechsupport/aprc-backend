module Types
  class PolicyCategoryType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :policies, [Types::PolicyType], null: true
    field :users, [Types::UserType], null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    field :has_edit_access, Boolean, null: true
    field :request_status, String, null: true
    field :request_edits, [Types::RequestEditType], null: true
    field :request_edit, Types::RequestEditType, null: true
    field :last_updated_by, String, null: true
    field :created_by, String, null: true
    field :status, String, null: true
    field :policy, [String], null: true


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

    def policy
      if object.class == Hash
        obj = object["policy"]
        obj.present? ? YAML.load(obj , :safe => true) : []
      else
        object&.policy
      end
    end
  end
end