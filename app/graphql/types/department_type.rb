module Types
  class DepartmentType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :users, [Types::UserType], null: true
    field :controls, [Types::ControlType], null: true

    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end