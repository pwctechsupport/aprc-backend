module Types
  class ControlType < BaseObject
    field :id, ID, null: false
    field :type_of_control, String, null: true
    field :frequency, String, null: true
    field :nature, String, null: true 
    field :assertion, String, null: true
    field :ipo, String, null: true
    field :control_owner, String, null: true
    field :description, String, null: true
    field :fte_estimate, Int, null: true
    field :business_processes, [Types::BusinessProcessType], null: true
    field :business_process_ids, [Types::BusinessProcessType], null: true
    field :risks, [Types::RiskType], null: true
    field :risk_ids, [Types::RiskType], null: true
  end
end