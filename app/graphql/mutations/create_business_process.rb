module Mutations
  class CreateBusinessProcess < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :status, Types::Enums::Status, required: false


    # return type from the mutation
    field :business_process, Types::BusinessProcessType, null: true

    def resolve(args)
      business_process = BusinessProcess.find_by(name: args[:name])
      if business_process.present?
        business_process.update_attributes(args.to_h)
      else
        business_process=BusinessProcess.create!(args.to_h)
      end

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