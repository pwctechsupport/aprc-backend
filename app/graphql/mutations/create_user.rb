module Mutations
  class CreateUser < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :role_ids, [ID], required: false
    argument :policy_category_ids, [ID], required: false
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :name, String, required: false
    argument :phone, String, required: false
    argument :status, Types::Enums::Status, required: false
    argument :department_id, ID, required: false
    argument :policy_category, [ID], as: :policy_category_ids,required: false
    argument :main_role, [ID], as: :role_ids,required: false


    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(args)
      if args[:policy_category_ids].present?
        relation_safe_array_polcat = []
        args[:policy_category_ids].each do |policy_category|
          policy_category_name = PolicyCategory.find(policy_category).name
          relation_safe_array_polcat.push(policy_category_name.html_safe)
        end
        args[:policy_category] = relation_safe_array_polcat
      end

      if args[:role_ids].present?
        relation_safe_array_role = []
        args[:role_ids].each do |role|
          role_name = Role.find(role).name
          relation_safe_array_role.push(role_name.html_safe)
        end
        args[:main_role] = relation_safe_array_role
      end

      user = User.new(args.to_h)
      user.save_draft
      current_user = context[:current_user]
      admin = User.with_role(:admin_reviewer).pluck(:id)
      if user.id.present?
        Notification.send_notification(admin,"#{current_user&.name} Create a User with email #{user&.email}" ,user.email, user, current_user&.id, "request_draft")
        user.update(status: "waiting_for_review" )

      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
      end

      MutationResult.call(
        obj: { user: user },
        success: user.persisted?,
        errors: user.errors.full_messages
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end