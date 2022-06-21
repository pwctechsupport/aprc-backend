module Mutations
  class CreateDescription < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :description, Types::DescriptionType, null: true

    def resolve(args)
      description = Description.where(name: args[:name]).first
      if description
        description.update_attributes(args.to_h)
      else
        description=Description.create!(args.to_h)
      end
      MutationResult.call(
          obj: { description: description },
          success: description.persisted?,
          errors: description.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end