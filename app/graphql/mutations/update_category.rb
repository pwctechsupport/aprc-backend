# frozen_string_literal: true

module Mutations
  class UpdateCategory < Mutations::BaseMutation
    graphql_name "UpdateCategory"

    argument :id, ID, required: true
    argument :name, String, required: false


    field :category, Types::CategoryType, null: false

    def resolve(id:, **args)
      category = Category.find(id)
      success = category.update_attributes(args.to_h)

      MutationResult.call(
        obj: { category: category },
        success: category.persisted?,
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