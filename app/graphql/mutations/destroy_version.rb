# frozen_string_literal: true

module Mutations
  class DestroyVersion < Mutations::BaseMutation
    graphql_name "DestroyVersion"

    argument :ids, [Int], required: true

    field :version, Boolean, null: false


    def resolve(ids:)
      version = PaperTrail::Version.where(id:ids)
      success = version.destroy_all
      MutationResult.call(
        obj: { version: version },
        success: success,
        errors: success
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