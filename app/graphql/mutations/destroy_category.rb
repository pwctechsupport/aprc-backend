# frozen_string_literal: true

module Mutations
  class DestroyCategory < Mutations::BaseMutation
    graphql_name "DestroyCategory"

    argument :id, ID, required: true

    field :category, Types::CategoryType, null: false

    def resolve(id:)
      category = Category.find(id)
      success = category.destroy
      
      MutationResult.call(
        obj: { category: category },
        success: success,
        errors: category.errors
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