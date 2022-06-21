# frozen_string_literal: true

module Mutations
    class DestroyPolicyCategory < Mutations::BaseMutation
      graphql_name "DestroyPolicyCategory"
  
      argument :id, ID, required: true
  
      field :policy_category, Types::PolicyCategoryType, null: false
  
      def resolve(id:)
        policy_category = PolicyCategory.find(id)
        success = policy_category.destroy
        
        MutationResult.call(
          obj: { policy_category: policy_category },
          success: success,
          errors: policy_category.errors
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