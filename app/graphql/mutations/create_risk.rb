module Mutations
  class CreateRisk < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :level_of_risk, Types::Enums::LevelOfRisk, required: true
    argument :status, Types::Enums::Status, required: false
    argument :type_of_risk, Types::Enums::TypeOfRisk, required: true 
    argument :control_ids, [ID], required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false
    argument :business_process, [ID], as: :business_process_ids,required: false

    

    # return type from the mutation
    field :risk, Types::RiskType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:created_by] = current_user&.name || "User with ID#{current_user&.id}"
      args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
      if args[:business_process_ids].present?
        args[:business_process] = args[:business_process_ids].map{|x| BusinessProcess.find(x&.to_i).name}
      end
      risk = Risk.new(args.to_h)
      risk.save_draft
      admin = User.with_role(:admin_reviewer).pluck(:id)
      if risk.id.present?
        Notification.send_notification(admin, risk&.name, risk&.type_of_risk,risk, current_user&.id, "request_draft")
      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
      end
      
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