module Types
  class RiskType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :status, String, null: true
    field :level_of_risk, String, null: true
  end
end