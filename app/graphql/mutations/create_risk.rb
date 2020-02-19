module Mutations
  class CreateRisk < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :level_of_risk, Types::Enums::LevelOfRisk, required: true
    argument :status, Types::Enums::Status, required: false
    argument :type_of_risk, Types::Enums::TypeOfRisk, required: false 
    argument :business_process_id, ID, required: false
    

    # return type from the mutation
    field :risk, Types::RiskType, null: true

    def resolve(args)
      current_user = context[:current_user]
      risk = Risk.new(args.to_h)
      risk.save_draft
      admin = User.with_role(:admin_reviewer).pluck(:id)
      Notification.send_notification(admin, risk&.name, risk&.type_of_risk,risk, current_user&.id)
      
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
  end
end