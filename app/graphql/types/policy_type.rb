module Types
  class PolicyType < BaseObject
    field :id, ID, null: false
    field :title, String, null: true
    field :description, String, null: true
    field :policy_category_id, ID, null: true
    field :user_id, ID, null: true
    field :resource_id, ID, null: true
    field :it_system_ids, [Types::ItSystemType], null: true
    field :resource_ids, [Types::ResourceType], null: true
    field :business_process_ids, [Types::BusinessProcessType], null: true
    field :control_ids, [Types::ControlType], null: true
    field :risk_ids, [Types::RiskType], null: true
    field :resources, [Types::ResourceType], null: true
    field :business_processes, [Types::BusinessProcessType], null: true
    field :it_systems, [Types::ItSystemType], null: true
    field :controls, [Types::ControlType], null: true
    field :risks, [Types::RiskType], null: true
    field :ancestry, ID, null: true
    field :parent_id, ID, null: true
    field :reference_ids, [Types::ReferenceType], null: true
    field :references, [Types::ReferenceType], null: true
    field :policy_category, Types::PolicyCategoryType, null: true
    field :status, String, null: true
    field :visit, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :policies_bookmarked_by, [Types::BookmarkPolicyType] , null: true
    field :user, Types::UserType, null:true
    field :sub_count, Types::BaseScalar, null: true
    field :control_count, Types::BaseScalar, null: true
    field :risk_count, Types::BaseScalar, null: true


    
    def policies_bookmarked_by
      bookmark = object.bookmark_policies
    end



    def control_count
      data = object.controls
      {
        total: data.count,
        draft: data.where(status: "draft").count,
        waiting_for_approval: data.where(status: "waiting_for_approval").count,
        release: data.where(status: "release").count,
        ready_for_edit: data.where(status: "ready_for_edit").count,
        waiting_for_review: data.where(status: "waiting_for_review").count  
      }
    end

    def risk_count
      data = object.risks
      {
        total: data.count,
        draft: data.where(status: "draft").count,
        waiting_for_approval: data.where(status: "waiting_for_approval").count,
        release: data.where(status: "release").count,
        ready_for_edit: data.where(status: "ready_for_edit").count,
        waiting_for_review: data.where(status: "waiting_for_review").count  
      }
    end


    def sub_count
      data = object.descendants
      {
        total: data.count,
        draft: data.where(status: "draft").count,
        waiting_for_approval: data.where(status: "waiting_for_approval").count,
        release: data.where(status: "release").count,
        ready_for_edit: data.where(status: "ready_for_edit").count,
        waiting_for_review: data.where(status: "waiting_for_review").count
      }
    end



    def policy_risks_count
      policy_risks = object.risks.count
    end


  end
end