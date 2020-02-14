module Mutations
  class AdminUpdateUser < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :user_id, ID, required: true
    argument :role_ids, [ID], required: false
    argument :user_policy_categories_attributes, [Types::BaseScalar], required: false
    argument :name, String, required: false
    argument :email, String, required: false
    argument :phone, String, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :jobPosition, String, required: false
    argument :department, String, required: false

    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(user_id:, **args)
      user = User.find(user_id)
      current_user = context[:current_user]

      if (args[:user_policy_categories_attributes].present? && !args[:date_decoy].present?) || (args[:user_policy_categories_attributes].present? ) 
        args[:user_policy_categories_attributes] = args[:user_policy_categories_attributes].map{|obj| obj.symbolize_keys}
        if user.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          if (args[:date_decoy] === nil) || user.date_decoy.present?
            args[:date_decoy] = Time.new.to_s
            if args[:role_ids].present?
              role = args[:role_ids]
              role_int = role[0].to_i
              args[:role_ids] = nil
              args[:role] = role_int
              args.delete(:role_ids)
              user.attributes = args
              user.deep_save_draft!
              admin = User.with_role(:admin).pluck(:id)
              Notification.send_notification(admin, user.name, user.email, user, current_user.id)
            else
              user.attributes = args
              user.deep_save_draft!
              admin = User.with_role(:admin).pluck(:id)
              Notification.send_notification(admin, user.name, user.email, user, current_user.id)
            end
          else
            if args[:role_ids].present?
              role = args[:role_ids]
              role_int = role[0].to_i
              args[:role_ids] = nil
              args[:role] = role_int
              args.delete(:role_ids)
              user.attributes = args
              user.deep_save_draft!
              admin = User.with_role(:admin).pluck(:id)
              Notification.send_notification(admin, user.name, user.email, user, current_user.id)
            else
              user.attributes = args
              user.deep_save_draft!
              admin = User.with_role(:admin).pluck(:id)
              Notification.send_notification(admin, user.name, user.email, user, current_user.id)
            end
          end
        end
      else
        if user.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          if args[:role_ids].present?
            role = args[:role_ids]
            role_int = role[0].to_i
            args[:role_ids] = nil
            args[:role] = role_int
            args.delete(:role_ids)
            user.attributes = args
            user.deep_save_draft!
            admin = User.with_role(:admin).pluck(:id)
            Notification.send_notification(admin, user.name, user.email, user, current_user.id)
          else
            user.attributes = args
            user.deep_save_draft!
            admin = User.with_role(:admin).pluck(:id)
            Notification.send_notification(admin, user.name, user.email, user, current_user.id)
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