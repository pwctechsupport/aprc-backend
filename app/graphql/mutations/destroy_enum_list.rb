# frozen_string_literal: true

module Mutations
  class DestroyEnumList < Mutations::BaseMutation
    graphql_name "DestroyEnumList"

    argument :id, ID, required: true

    field :enum_list, Types::EnumListType, null: false

    def resolve(id:)
      enum_list = EnumList.find(id)
      success = enum_list.destroy
      
      MutationResult.call(
        obj: { enum_list: enum_list },
        success: success,
        errors: enum_list.errors
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