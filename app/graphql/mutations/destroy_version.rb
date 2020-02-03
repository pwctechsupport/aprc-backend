# frozen_string_literal: true

module Mutations
  class DestroyVersion < Mutations::BaseMutation
    graphql_name "DestroyVersion"

    argument :id, ID, required: true

    field :version, Types::VersionType, null: false

    def resolve(id:)
      version = PaperTrail::Version.find(id)
      success = version.destroy
      
      MutationResult.call(
        obj: { version: version },
        success: success,
        errors: version.errors
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