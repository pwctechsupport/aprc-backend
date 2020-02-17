# frozen_string_literal: true

module Mutations
  class UpdateRisk < Mutations::BaseMutation
    graphql_name "UpdateRisk"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :status, Types::Enums::Status, required: false
    argument :level_of_risk, Types::Enums::LevelOfRisk, required: false
    argument :type_of_risk, Types::Enums::TypeOfRisk, required: false 
    argument :business_process_id, ID, required: false




    field :risk, Types::RiskType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      risk = Risk.find(id)
      if risk.draft?
        raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
      else
        risk.attributes = args
        risk.save_draft
        admin = User.with_role(:admin).pluck(:id)
        Notification.send_notification(admin, risk&.name, risk&.type_of_risk,risk, current_user&.id)
      end

      MutationResult.call(
        obj: { risk: risk },
        success: success,
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