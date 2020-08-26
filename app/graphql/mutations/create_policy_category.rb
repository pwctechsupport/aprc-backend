module Mutations
  class CreatePolicyCategory < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :policy_ids, [ID], required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false
    argument :status, Types::Enums::Status, required: false
    argument :policy, [ID], as: :policy_ids,required: false




    # return type from the mutation
    field :policy_category, Types::PolicyCategoryType, null: true

    def resolve(args)
      current_user = context[:current_user]

      args[:created_by] = current_user.name
      args[:last_updated_by] = current_user.name
      if args[:policy_ids].present?
        args[:policy] = args[:policy_ids].map{|x| Policy.find(x).title}
      end

      policy_category = current_user&.policy_categories&.new(args.to_h)
      policy_category&.save_draft
      admin = User.with_role(:admin_reviewer).pluck(:id)
      if policy_category.id.present?
        Notification.send_notification(admin, policy_category&.name, policy_category&.name,policy_category, current_user&.id, "request_draft")
        policy_category.update(status: "waiting_for_review" )
      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
      end
      MutationResult.call(
          obj: { policy_category: policy_category },
          success: policy_category.persisted?,
          errors: policy_category.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end