module Types
  class RiskType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :status, String, null: true
    field :level_of_risk, String, null: true
    field :type_of_risk, String, null: true
    field :business_process_id, ID, null: true
    field :business_process, Types::BusinessProcessType, null: true
    field :policies, [Types::PolicyType], null: false
    field :controls, [Types::ControlType], null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :risks_bookmarked_by, [Types::BookmarkRiskType] , null: true
    field :user, Types::UserType, null:true
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    
    def risks_bookmarked_by
      bookmark = object.bookmark_risks
    end
  end
end