# frozen_string_literal: true

module Mutations
  class UpdateItSystem < Mutations::BaseMutation
    graphql_name "UpdateItSystem"

    argument :id, ID, required: true
    argument :name, String, required: false


    field :it_system, Types::ItSystemType, null: false

    def resolve(id:, **args)
      it_system = ItSystem.find(id)
      success = it_system.update_attributes(args.to_h)

      MutationResult.call(
        obj: { it_system: it_system },
        success: it_system.persisted?,
        errors: it_system.errors
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