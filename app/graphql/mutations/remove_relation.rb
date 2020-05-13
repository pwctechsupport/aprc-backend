
module Mutations
  class RemoveRelation < Mutations::BaseMutation
    graphql_name "RemoveRelation"

    argument :originator_id, ID, required: true
    argument :resource_id, ID, required: true
    argument :originator_type, String, required: true

    field :policy_resource, Types::PolicyResourceType, null: true
    field :resource, Types::ResourceType, null:true

    def resolve(args)
      case args[:originator_type]
      when "Policy"
        policy_resource = PolicyResource.where(policy_id:args[:originator_id], resource_id: args[:resource_id]).first
        success = policy_resource.destroy
        MutationResult.call(
          obj: {policy_resource: policy_resource},
          success: policy_resource.persisted?,
          errors: policy_resource.errors
        )
        
      when "BusinessProcess"
        resource = Resource.find(args[:originator_id])
        resource&.update(business_process_id: nil)
        MutationResult.call(
          obj: {resource: resource},
          success: resource.persisted?,
          errors: resource.errors
        )
      end
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    # def ready?(args)
    #   authorize_user
    # end
  end
end