module Types
  class ResourceType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :resuploadUrl, String, null: true
    field :category_id, ID, null: true
    field :category, Types::CategoryType, null: true
    field :policy_id, ID, null: true
    field :policy, Types::PolicyType, null: true
    field :control_id, ID, null: true
    field :control, Types::ControlType, null: true
    field :business_process_id, ID, null: true
    field :business_process, Types::BusinessProcessType, null: true
    def  resupload_url
      attachment = object.resupload.url
    end
  end
end