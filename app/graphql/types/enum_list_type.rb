module Types
  class EnumListType < BaseObject
    field :name, String, null: true
    field :code, String, null: true
    field :category_type, String, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end