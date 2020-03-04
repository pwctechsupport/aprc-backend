# frozen_string_literal: true

module Mutations
  class UpdateEnumList < Mutations::BaseMutation
    graphql_name "UpdateEnumList"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :code, String, required: false
    argument :category_type, String, required: false


    field :enum_list, Types::EnumListType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      enum_list = EnumList.find(id)
      enum_list.update(args.to_h)

      
      MutationResult.call(
        obj: { enum_list: enum_list },
        success: enum_list.persisted?,
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