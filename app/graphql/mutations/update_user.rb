# frozen_string_literal: true

module Mutations
    class UpdateUser < Mutations::BaseMutation
      graphql_name "UpdateUser"

      argument :email, String, required: false
      argument :phone, String, required: false
      argument :password, String, required: false
      argument :password_confirmation, String, required: false
      argument :name, String, required: false
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :jobPosition, String, required: false
      argument :department, String, required: false
  
      field :user, Types::UserType, null: false
     
      def resolve(args)
        user = context[:current_user]
        if args[:password].present? && args[:password_confirmation].present?
          if user.draft?
            raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
          else
            user.attributes = args
            user.save_draft
            admin = User.with_role(:admin_reviewer).pluck(:id)
            if user.draft.present?
              Notification.send_notification(admin, user.name, user.email, user, user.id, "request_draft")
            else
            end
          end
        end

        MutationResult.call(
          obj: { user: user },
          success: user.persisted?,
          errors: user.errors
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