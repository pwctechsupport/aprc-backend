module Types
  class BusinessProcessType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :ancestry, ID, null: true
    field :parent_id, ID, null: true
  end
end