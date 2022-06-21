module Types
  class ControlType < BaseObject
    field :id, ID, null: false
    field :type_of_control, String, null: true
    field :frequency, String, null: true
    field :nature, String, null: true 
    field :assertion, [String], null: true
    field :ipo, [String], null: true
    field :control_owner, [String], null: true
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
    field :file_attachments, [Types::FileAttachmentType], null: true
    field :activity_controls, [Types::ActivityControlType], null: true
    field :has_edit_access, Boolean, null: true
    field :request_status, String, null: true
    field :request_edits, [Types::RequestEditType], null: true
    field :request_edit, Types::RequestEditType, null: true
    field :tags, [Types::TagType], null: true
    field :last_updated_by, String, null: true
    field :created_by, String, null: true
    field :departments, [Types::DepartmentType], null: true

    def business_processes
      if object&.class == Hash
        bispro_ids = ControlBusinessProcess.where(control_id: object["id"]).where.not(draft: nil).pluck(:business_process_id)
        BusinessProcess.where(id: bispro_ids)
      else
        object&.business_processes
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
    
    def controls_bookmarked_by
      bookmark = object.bookmark_controls
    end

    def assertion
      if object&.try(:assertion)&.class == Array
        object&.assertion
      else
        object["assertion"]&.gsub(/([-() ])/, '')&.split("\n")&.reject(&:empty?)
      end
    end

    def ipo
      if object&.try(:ipo).class == Array
        object&.ipo
      else
        object["ipo"]&.gsub(/([-() ])/, '')&.split("\n")&.reject(&:empty?)
      end
    end

    def control_owner
      if object.class == Hash
        obj = object["control_owner"]
        obj.present? ? Psych.parse(obj).to_ruby : []
      else
        object&.control_owner
      end
    end
  end
end