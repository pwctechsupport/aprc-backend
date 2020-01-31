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
    field :visit, Int, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :policies_bookmarked_by, [Types::BookmarkPolicyType] , null: true
    field :user, Types::UserType, null:true
    field :sub_count, Types::BaseScalar, null: true
    field :control_count, Types::BaseScalar, null: true
    field :risk_count, Types::BaseScalar, null: true
    field :version_before, Types::BaseScalar, null: true
    field :revert_to_previous_version, Types::BaseScalar, null: true
    field :total_versions, Int, null: true
    field :undelete_version, Types::BaseScalar, null: true 
    field :navigate_version, Types::BaseScalar, null: true do
      argument :n, Int, required: true
      argument :revert, Types::Enums::RevertConfirmation, required: true
    end
    

    
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

  #   def version_before
  #     data = object.versions.last.reify
  #     if data === nil
  #       data = "Deleted Version of the Data"
  #     else
  #       dato= object.versions.last
  #       dati = dato.whodunnit.to_i
  #       if dati === nil
  #         dati = "There is no User"
  #         {
  #           id: data.id,
  #           title:data.title,
  #           description:data.description,
  #           policy_category_id:data.policy_category_id,
  #           created_at:data.created_at,
  #           updated_at:data.updated_at,
  #           parent:data.parent_id,
  #           status:data.status,
  #           visit:data.visit,
  #           id:dato.id,
  #           item_type:dato.item_type,
  #           item_id:dato.item_id,
  #           event:dato.event,
  #           modified_by:dati,
  #           changed_at:dato.created_at
  #         }
  #       else
  #         {
  #           id: data.id,
  #           title:data.title,
  #           description:data.description,
  #           policy_category_id:data.policy_category_id,
  #           created_at:data.created_at,
  #           updated_at:data.updated_at,
  #           parent:data.parent_id,
  #           status:data.status,
  #           visit:data.visit,
  #           id:dato.id,
  #           item_type:dato.item_type,
  #           item_id:dato.item_id,
  #           event:dato.event,
  #           modified_by:User.find_by(id: dati).name,
  #           changed_at:dato.created_at
  #         }
  #       end
  #     end
  #   end
    
  #   def revert_to_previous_version
  #     data = object.paper_trail.previous_version
  #     if data === nil
  #       data = "Deleted Version of the Data"
  #     else
  #       data.save
  #       {
  #         id: data.id,
  #         title:data.title,
  #         description:data.description,
  #         policy_category_id:data.policy_category_id,
  #         created_at:data.created_at,
  #         updated_at:data.updated_at,
  #         parent:data.parent_id,
  #         status:data.status,
  #         visit:data.visit
  #       }
  #     end
  #   end

  #   def total_versions
  #     data = object.versions.length
  #   end

  #   def undelete_version
  #     versioni = object.versions
  #     data = versioni.last.reify(has_many: true, has_many_through: true, belongs_to: true)
  #     if data === nil
  #       data = "Deleted Version of the Data"
  #     else
  #       data.save
  #       {
  #         id: data.id,
  #         title:data.title,
  #         description:data.description,
  #         policy_category_id:data.policy_category_id,
  #         created_at:data.created_at,
  #         updated_at:data.updated_at,
  #         parent:data.parent_id,
  #         status:data.status,
  #         visit:data.visit
  #       }
  #     end
  #   end

  #   def navigate_version(n:, revert:)
  #     x = n-1
  #     data = object.versions[x].reify
  #     if data === nil
  #       data = "Deleted Version of the Data"
  #     elsif revert === "yes"
  #       data.save
  #       {
  #       id: data.id,
  #       title:data.title,
  #       description:data.description,
  #       policy_category_id:data.policy_category_id,
  #       created_at:data.created_at,
  #       updated_at:data.updated_at,
  #       parent:data.parent_id,
  #       status:data.status,
  #       visit:data.visit
  #       }
  #     else
  #       {
  #       id: data.id,
  #       title:data.title,
  #       description:data.description,
  #       policy_category_id:data.policy_category_id,
  #       created_at:data.created_at,
  #       updated_at:data.updated_at,
  #       parent:data.parent_id,
  #       status:data.status,
  #       visit:data.visit
  #       }
  #     end
  #   end 



    def policy_risks_count
      policy_risks = object.risks.count
    end


  end
end