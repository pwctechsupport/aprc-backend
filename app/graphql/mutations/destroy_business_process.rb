# frozen_string_literal: true

module Mutations
  class DestroyBusinessProcess < Mutations::BaseMutation
    graphql_name "DestroyBusinessProcess"

    argument :id, ID, required: true

    field :business_process, Types::BusinessProcessType, null: false

    def resolve(id:)
      business_process = BusinessProcess.find(id)
      success = business_process.destroy
      
      MutationResult.call(
        obj: { business_process: business_process },
        success: success,
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