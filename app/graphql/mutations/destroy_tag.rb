# frozen_string_literal: true

module Mutations
  class DestroyTag < Mutations::BaseMutation
    graphql_name "DestroyTag"

    argument :id, ID, required: true

    field :tag, Types::TagType, null: false

    def resolve(id:)
      tag = Tag.find(id)
      success = tag.destroy
      
      MutationResult.call(
        obj: { tag: tag },
        success: success,
        errors: tag.errors
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