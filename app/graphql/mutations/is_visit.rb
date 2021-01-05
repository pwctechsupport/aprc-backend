module Mutations
  class IsVisit < Mutations::BaseMutation
    argument :originator_id, ID, required: true
    argument :originator_type, String, required: true

    field :policy, Types::PolicyType, null: true
    field :resource, Types::ResourceType, null:true


    def resolve(args)
      case args[:originator_type]
      when "Policy"
        policy = Policy.find(args[:originator_id])
        vieu = policy&.visit+1
        policy&.update_columns(visit: vieu)
        MutationResult.call(
          obj: {policy: policy},
          success: policy.persisted?,
          errors: policy.errors
        )
        
      when "Resource"
        resource = Resource.find(args[:originator_id])
        vieu = resource&.visit+1
        resource&.update(visit: vieu)
        MutationResult.call(
          obj: {resource: resource},
          success: resource.persisted?,
          errors: resource.errors
        )
      end
      # request_edit = current_user.request_edit_risks.create!(args.to_h)
      
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

  end
end