# frozen_string_literal: true

module Mutations
    class UpdateUser < Mutations::BaseMutation
      graphql_name "UpdateUser"

      argument :email, String, required: false
      argument :phone, String, required: false
      argument :password, String, required: false
      argument :password_confirmation, String, required: false
      argument :name, String, required: false
      argument :jobPosition, String, required: false
      argument :department, String, required: false
  
      field :user, Types::UserType, null: false
  
      def resolve(args)
        user = context[:current_user]
        if args[:password].present? && args[:password_confirmation].present?
          user.update!(args)
        else
          user.update_attributes(args)
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