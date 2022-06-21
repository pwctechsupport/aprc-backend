

module Mutations
  class UpdateReference < Mutations::BaseMutation
    graphql_name "UpdateReference"
    
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :status, Types::Enums::Status, required: false
    argument :policy_ids, [ID], required: false
    argument :last_updated_by, String, required: false


    
    
    
    field :reference, Types::ReferenceType, null: false
    
    def resolve(id:, name: nil, status: nil, policy_ids: nil, last_updated_by: nil)
      current_user = context[:current_user]
      reference = Reference.find(id)
      reference_update = reference.update_attributes!(
        name: '#' << name,
        status: status,
        policy_ids: policy_ids,
        last_updated_by: current_user&.name || "User with ID#{current_user&.id}"
      )
      lovar= reference.name.count "#"
      
      if lovar > 1
        refa= reference.name.gsub('#','')
        refu = '#' << refa 
        reference.update_attributes!(name: refu)
      end

      MutationResult.call(
        obj: { reference: reference },
        success: reference.persisted?,
        errors: reference.errors
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