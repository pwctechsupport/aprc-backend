module Types
  class TagType < BaseObject
    field :x_coordinates, Int, null: true
    field :y_coordinates, Int, null: true
    field :resource_id, ID, null: true
    field :business_process_id, ID, null: true
    field :user_id, ID, null: true
    field :user, Types::UserType, null: true
    field :resource, Types::ResourceType, null: true
    field :business_process, Types::BusinessProcessType, null: true
    field :body, String, null: true
    field :image_name, String, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :control, Types::ControlType, null: true
    field :risk, Types::RiskType, null: true
  end
end