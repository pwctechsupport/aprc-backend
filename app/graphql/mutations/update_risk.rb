# frozen_string_literal: true

module Mutations
  class UpdateRisk < Mutations::BaseMutation
    graphql_name "UpdateRisk"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :status, Types::Enums::Status, required: false
    argument :level_of_risk, Types::Enums::LevelOfRisk, required: false
    argument :type_of_risk, Types::Enums::TypeOfRisk, required: false 
    argument :business_process_ids, [ID], required: false
    argument :control_ids, [ID], required: false
    argument :last_updated_by, String, required: false
    argument :business_process, [ID], as: :business_process_ids,required: false





    field :risk, Types::RiskType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      risk = Risk.find(id)
      if risk&.request_edits&.last&.approved?
        if risk.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          if args[:control_ids].present?
            args[:is_related] = true
          end
          args[:created_by] = current_user&.name || "User with ID#{current_user&.id}"
          args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
          if args[:business_process_ids].present?
            args[:business_process] = args[:business_process_ids].map{|x| BusinessProcess.find(x&.to_i).name}
          end
          risk.attributes = args
          risk.save_draft
          if risk&.draft_id.present?
            if risk.draft.event == "update"
              if args[:business_process].present? 
                serial = ["business_process"]
                serial.each do |sif|
                  if risk.draft.changeset[sif].present?
                    risk.draft.changeset[sif].map!{|x| JSON.parse(x)}
                  end
                end
              end
              pre_ris = risk.draft.changeset.map {|x,y| Hash[x, y[0]]}
              pre_ris.map {|x| risk.update(x)}
            end
          end

          admin = User.with_role(:admin_reviewer).pluck(:id)
          if risk.draft.present?
            Notification.send_notification(admin, risk&.name, risk&.type_of_risk,risk, current_user&.id, "request draft")
            risk.update(status:"waiting_for_review")
          end
        end
      else
        raise GraphQL::ExecutionError, "Request not granted. Please Check Your Request Status"
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

    def ready?(args)
      authorize_user
    end
  end
end