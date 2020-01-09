# frozen_string_literal: true

module Mutations
  class UpdateBusinessProcess < Mutations::BaseMutation
    graphql_name "UpdateBusinessProcess"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :status, Types::Enums::Status, required: false



    field :business_process, Types::BusinessProcessType, null: false

    def resolve(id:, **args)
      business_process = BusinessProcess.find(id)
      business_process.update_attributes!(args.to_h)

      MutationResult.call(
        obj: { business_process: business_process },
        success: business_process.persisted?,
        errors: business_process.errors
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