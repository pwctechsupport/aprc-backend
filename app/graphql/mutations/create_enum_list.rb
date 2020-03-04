module Mutations
  class CreateEnumList < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: false
    argument :code, String, required: false
    argument :category_type, String, required: false


    # return type from the mutation
    field :enum_list, Types::EnumListType, null: true

    def resolve(args)
      enum_list = EnumList.create!(args.to_h)
      
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
  end
end