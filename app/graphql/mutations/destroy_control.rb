# frozen_string_literal: true

module Mutations
  class DestroyControl < Mutations::BaseMutation
    graphql_name "DestroyControl"

    argument :id, ID, required: true

    field :control, Types::ControlType, null: false

    def resolve(id:)
      control = Control.find(id)
      success = control.destroy
      
      MutationResult.call(
        obj: { control: control },
        success: success,
        errors: control.errors
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