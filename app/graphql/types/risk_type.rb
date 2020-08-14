module Types
  class RiskType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :status, String, null: true
    field :level_of_risk, String, null: true
    field :type_of_risk, String, null: true
    field :business_processes, [Types::BusinessProcessType], null: true
    field :policies, [Types::PolicyType], null: true
    field :controls, [Types::ControlType], null: true
    field :created_at, String, null: true
    field :updated_at, String, null: true
    field :risks_bookmarked_by, [Types::BookmarkRiskType] , null: true
    field :user, Types::UserType, null:true
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    field :has_edit_access, Boolean, null: true
    field :request_status, String, null: true
    field :request_edits, [Types::RequestEditType], null: true
    field :request_edit, Types::RequestEditType, null: true
    field :tags, [Types::TagType], null: true
    field :last_updated_by, String, null: true
    field :created_by, String, null: true
    field :business_process, [String], null: true


    

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
    
    def risks_bookmarked_by
      bookmark = object.bookmark_risks
    end

    def business_process
      if object.class == Hash
        obj = object["business_process"]
        obj.present? ? SafeYAML.load(obj) : []
      else
        object&.business_process
      end
    end

  end
end