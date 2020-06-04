module Mutations
  class CreateBusinessProcess < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :status, Types::Enums::Status, required: false
    argument :risk_ids, [ID], required: false
    argument :control_ids, [ID], required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false


    # return type from the mutation
    field :business_process, Types::BusinessProcessType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:created_by] = current_user&.name || "User with ID#{current_user&.id}"
      args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
      business_process=BusinessProcess.create!(args.to_h)

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
  end
end