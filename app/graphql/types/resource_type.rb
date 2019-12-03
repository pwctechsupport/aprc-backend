module Types
  class ResourceType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :resuploadUrl, String, null: true
    field :category, String, null: true
    field :policy_ids, [Types::PolicyType], null: true
    field :policies, [Types::PolicyType], null: true
    field :control_ids, [Types::ControlType], null: true
    field :controls, [Types::ControlType], null: true
    field :business_process_id, ID, null: true
    field :business_process, Types::BusinessProcessType, null: true
    def  resupload_url
      attachment = object.resupload.url
    end

    def policies
      current_user = context[:current_user]
      current_user.policies
    end
  end
end