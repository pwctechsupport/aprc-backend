# frozen_string_literal: true

module Mutations
    class UpdateUser < Mutations::BaseMutation
      graphql_name "UpdateUser"

      argument :email, String, required: false
      argument :phone, String, required: false
      argument :name, String, required: false
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :jobPosition, String, required: false
      argument :department_id, ID, required: false
      argument :notif_show, Boolean, required: false
      argument :status, Types::Enums::Status, required: false

  
      field :user, Types::UserType, null: false
  
      def resolve(args)
        user = context[:current_user]
        
        if args[:notif_show].present?
          user.update!(notif_show: args[:notif_show])
        else
          user.update_attributes(args.to_h)
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