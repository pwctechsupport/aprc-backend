module Types
  class PolicyType < BaseObject
    field :id, ID, null: false
    field :title, String, null: true
    field :description, String, null: true
    field :policy_category_id, ID, null: true
    field :user_id, ID, null: true
    field :it_system_ids, [Types::ItSystemType], null: true
    field :resource_ids, [Types::ResourceType], null: true
    field :business_process_ids, [Types::BusinessProcessType], null: true
    field :resources, [Types::ResourceType], null: true
    field :business_processes, [Types::BusinessProcessType], null: true
    field :it_systems, [Types::ItSystemType], null: true
    field :ancestry, ID, null: true
    field :parent_id, ID, null: true
    field :reference_ids, [Types::ReferenceType], null: true
    field :references, [Types::ReferenceType], null: true
    field :policy_category, Types::PolicyCategoryType, null: true
    field :status, String, null: true

  end
end