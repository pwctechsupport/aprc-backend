module Mutations
  class UpdateTag < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :id, ID, required: true
    argument :body, String, required: false
    argument :control_id, ID, required: false
    argument :risk_id, ID, required: false


    # return type from the mutation
    field :tag, Types::TagType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      args[:user_id] = current_user&.id  
      tag = Tag.find(id)
      if args[:control_id].present?
        tagged = (Tag.find_by(resource_id: tag.resource_id,business_process_id: tag.business_process_id,control_id: args[:control_id])) 
        if !(tagged.present?)
          tag.update(args.to_h)
          tag.update(risk_id: nil)
          args.delete(:control_id)
        else
          raise GraphQL::ExecutionError, "This Control has been Selected to another tag."
        end
      elsif args[:risk_id].present?
        tagged = (Tag.find_by(resource_id: tag.resource_id,business_process_id: tag.business_process_id,risk_id: args[:risk_id])) 
        if !(tagged.present?)
          tag.update(args.to_h)
          tag.update(control_id: nil)
          args.delete(:risk_id)
        else
          raise GraphQL::ExecutionError, "This Control has been Selected to another tag."
        end
      end
      
      MutationResult.call(
          obj: { tag: tag },
          success: tag.persisted?,
          errors: tag.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end