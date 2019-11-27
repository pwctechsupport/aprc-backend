# frozen_string_literal: true

module Mutations
  class DestroyItSystem < Mutations::BaseMutation
    graphql_name "DestroyItSystem"

    argument :id, ID, required: true

    field :it_system, Types::ItSystemType, null: false

    def resolve(id:)
      it_system = ItSystem.find(id)
      success = it_system.destroy
      
      MutationResult.call(
        obj: { it_system: it_system },
        success: success,
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