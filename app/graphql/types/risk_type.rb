module Types
  class RiskType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
  end
end