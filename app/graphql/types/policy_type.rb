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
    field :parent_id, ID, null: true
    field :parent, Types::PolicyType, null: true
    field :children, [Types::PolicyType], null: true
    field :ancestors, [Types::PolicyType], null: true
    field :status, String, null: true
    field :visit, Int, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :policies_bookmarked_by, [Types::BookmarkPolicyType] , null: true
    field :published_at, String, null: true
    field :user, Types::UserType, null:true
    field :sub_count, Types::BaseScalar, null: true
    field :control_count, Types::BaseScalar, null: true
    field :risk_count, Types::BaseScalar, null: true
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    field :has_edit_access, Boolean, null: true
    field :request_status, String, null: true
    field :request_edits, [Types::RequestEditType], null: true
    field :request_edit, Types::RequestEditType, null: true
    field :file_attachments, [Types::FileAttachmentType], null: true
    field :ancestors, [Types::PolicyType], null: true
    field :recent_visit, String, null: true
    field :versions_count, String, null: true
    field :descendants_controls, [Types::ControlType], null: true
    field :descendants_risks, [Types::RiskType], null: true
    field :is_submitted, Boolean, null: true
    field :created_by, String, null: true
    field :last_updated_by, String, null: true
    field :last_updated_at, String, null: true
    field :true_version, Float, null: true
    field :bookmarked_by, Boolean, null: true

    def references
      if object&.class == Hash
        ref_ids = PolicyReference.where(policy_id: object["id"]).where.not(draft: nil).pluck(:reference_id)
        Reference.where(id: ref_ids)
      else
        Reference.where(id: object.reference_ids)
      end  
    end

    def bookmarked_by
      if object.bookmarks.present?
        true
      else
        false
      end
    end

    def versions_count
      ver = object.versions.count.to_f
      ver.to_s
    end

    def descendants_controls
      if context[:current_user].has_role?(:admin_reviewer)
        descendants = object.descendants.where.not(status: "draft").map {|x| x.controls}.flatten
        data        = if object.status != 'draft' then object.controls + descendants else descendants end
      elsif context[:current_user].has_role?(:user)
        descendants = object.descendants.where.not(status: [ "draft", "waiting_for_review" ]).map {|x| x.controls}.flatten
        data        = if object.status != 'draft' || object.status != 'waiting_for_review' then object.controls + descendants else descendants end
      else
        data        = object.controls + object.descendants.map {|x| x.controls}.flatten
      end
      return data.uniq
    end

    def descendants_risks
      if context[:current_user].has_role?(:admin_reviewer)
        descendants = object.descendants.where.not(status: "draft").map {|x| x.risks}.flatten
        data        = if object.status != 'draft' then object.risks + descendants else descendants end
      elsif context[:current_user].has_role?(:user)
        descendants = object.descendants.where.not(status: [ "draft", "waiting_for_review" ]).map {|x| x.risks}.flatten
        data        = if object.status != 'draft' || object.status != 'waiting_for_review' then object.risks + descendants else descendants end
      else
        data        = object.risks + object.descendants.map {|x| x.risks}.flatten
      end
      return data.uniq
    end

    def ancestors
      object&.ancestors
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

    
    def policies_bookmarked_by
      bookmark = object.bookmark_policies
    end

    def control_count
      data = descendants_controls
      {
        total: data.count,
        draft: data.select{|a| a.status == "draft" }.count,
        waiting_for_approval: data.select{|a| a.status == "waiting_for_approval" }.count,
        release: data.select{|a| a.status == "release" }.count,
        ready_for_edit: data.select{|a| a.status == "ready_for_edit" }.count,
        waiting_for_review: data.select{|a| a.status == "waiting_for_review" }.count 
      }
    end


    def risk_count
      data = descendants_risks
      {
        total: data.count,
        draft: data.select{|a| a.status == "draft" }.count,
        waiting_for_approval: data.select{|a| a.status == "waiting_for_approval" }.count,
        release: data.select{|a| a.status == "release" }.count,
        ready_for_edit: data.select{|a| a.status == "ready_for_edit" }.count,
        waiting_for_review: data.select{|a| a.status == "waiting_for_review" }.count 
      }
    end

    def sub_count
      if context[:current_user].has_role?(:admin_reviewer)
        data = object.descendants.where.not(status: "draft")
      elsif context[:current_user].has_role?(:user)
        data = object.descendants.where.not(status: [ "draft", "waiting_for_review" ])
      else
        data = object.descendants
      end
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