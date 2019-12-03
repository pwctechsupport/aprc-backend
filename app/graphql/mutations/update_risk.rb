# frozen_string_literal: true

module Mutations
  class UpdateRisk < Mutations::BaseMutation
    graphql_name "UpdateRisk"

    argument :id, ID, required: true
    argument :name, String, required: false


    field :risk, Types::RiskType, null: false

    def resolve(id:, **args)
      risk = Risk.find(id)
      success = risk.update_attributes(args.to_h)

      MutationResult.call(
        obj: { risk: risk },
        success: risk.persisted?,
        errors: risk.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    # def ready?(args)
    #   authorize_user
    # end
  end
end