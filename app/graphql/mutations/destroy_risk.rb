# frozen_string_literal: true

module Mutations
  class DestroyRisk < Mutations::BaseMutation
    graphql_name "DestroyRisk"

    argument :id, ID, required: true

    field :risk, Types::RiskType, null: false

    def resolve(id:)
      risk = Risk.find(id)
      success = risk.destroy
      
      MutationResult.call(
        obj: { risk: risk },
        success: success,
        errors: risk.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    def ready?(args)
      authorize_user
    end
  end
end