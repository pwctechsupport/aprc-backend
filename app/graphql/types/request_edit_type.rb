module Types
  class RequestEditType < BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: true
    field :approver_id, ID, null:true
    field :originator_type, String, null: true
    field :originator_id, ID, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :state, String, null:true
    field :originator, Types::OriginatorType, null: true
    field :user, Types::UserType, null: true
    field :approver, Types::UserType, null: true
  end
end
