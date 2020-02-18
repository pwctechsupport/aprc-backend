module Types
  class ControlType < BaseObject
    field :id, ID, null: false
    field :type_of_control, String, null: true
    field :frequency, String, null: true
    field :nature, String, null: true 
    field :assertion, [String], null: true
    field :ipo, [String], null: true
    field :control_owner, String, null: true
    field :description, String, null: true
    field :fte_estimate, Int, null: true
    field :business_processes, [Types::BusinessProcessType], null: true
    field :business_process_ids, [Types::BusinessProcessType], null: true
    field :risks, [Types::RiskType], null: true
    field :risk_ids, [Types::RiskType], null: true
    field :descriptions, [Types::DescriptionType], null: true
    field :status, String, null: true
    field :description_ids, [Types::DescriptionType], null: true
    field :policies, [Types::PolicyType], null: true
    field :resources, [Types::ResourceType], null: true
    field :created_at, String, null: true
    field :updated_at, String, null: true
    field :controls_bookmarked_by, [Types::BookmarkControlType] , null: true
    field :user, Types::UserType, null:true
    field :key_control, Boolean, null:true
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    
    def controls_bookmarked_by
      bookmark = object.bookmark_controls
    end

    def assertion
      if object.try(:assertion).class == Array
        object.assertion
      else
        object["assertion"].gsub(/([-() ])/, '').split("\n").reject(&:empty?)
      end
    end

    def ipo
      if object.try(:ipo).class == Array
        object.ipo
      else
        object["ipo"].gsub(/([-() ])/, '').split("\n").reject(&:empty?)
      end
    end

  end
end