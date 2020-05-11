module Types
  class BusinessProcessType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :ancestry, ID, null: true
    field :parent_id, ID, null: true
    field :parent, Types::BusinessProcessType, null: true
    field :children, [Types::BusinessProcessType], null: true
    field :ancestors, [Types::BusinessProcessType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :policies, [Types::PolicyType], null: true
    field :resources, [Types::ResourceType], null: true
    field :controls, [Types::ControlType], null: true
    field :risks, [Types::RiskType], null: true
    field :status, String, null: true
    field :tags, [Types::TagType], null: true
    field :ancestors, [Types::BusinessProcessType], null: true
    field :last_updated_by, String, null: true
    field :created_by, String, null: true
    field :bookmarked_by, Boolean, null: true


    def bookmarked_by
      if object.bookmarks.present?
        true
      else
        false
      end
    end

    def ancestors
      object&.ancestors
    end
  end
end