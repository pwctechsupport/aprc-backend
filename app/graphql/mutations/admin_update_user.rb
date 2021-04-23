module Mutations
  class AdminUpdateUser < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :user_id, ID, required: true
    argument :role_ids, [ID], required: false
    argument :policy_category_ids, [ID], required: false
    argument :name, String, required: false
    argument :email, String, required: false
    argument :phone, String, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :jobPosition, String, required: false
    argument :department_id, ID, required: false
    argument :status, Types::Enums::Status, required: false
    argument :policy_category, [ID], as: :policy_category_ids,required: false
    argument :main_role, [ID], as: :role_ids,required: false



    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(user_id:, **args)
      user = User.find(user_id)
      current_user = context[:current_user]
      if user&.request_edits&.last&.approved?
        if user.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          if args[:policy_category_ids].present?
            upc = UserPolicyCategory.where(user_id: user.id)
            if upc
              # delete upc if not exist in policy_category_ids args
              check = upc.where.not(policy_category_id: args[:policy_category_ids])
              if check
                check.delete_all
              end
              upc.each do |u|
                args[:policy_category_ids].delete_if {|i| i == u.policy_category_id.to_s}
              end
              
              if args[:policy_category_ids].present?
                args[:policy_category_ids].each do |id|
                  pol = UserPolicyCategory.new(user_id: user.id, policy_category_id: id )
                  pol.save_draft
                end 
              end
            end
            args[:policy_category]  = user.user_policy_categories.map{|x| x.policy_category_id}.map{|x| PolicyCategory.find(x&.to_i).name}
            user.policy_category    = args[:policy_category]
          end

          if args[:role_ids].present?
            args[:main_role]  = args[:role_ids].map{|x| Role.find(x&.to_i).name}
            user.main_role    = args[:main_role]
          end

          # user&.attributes = args
          user.name = args[:name]
          user.department_id = args[:department_id]
          user&.save_draft

          # if user&.draft_id.present?
          #   if user.draft.event == "update"
          #     if args[:policy_category].present?
          #       serial = ["policy_category"]
          #       serial.each do |sif|
          #         if user.draft.changeset[sif].present?
          #           user.draft.changeset[sif].map!{|x| JSON.parse(x)}
          #         end
          #       end
          #     end
          #     if args[:main_role].present?
          #       serial = ["main_role"]
          #       serial.each do |sif|
          #         if user.draft.changeset[sif].present?
          #           user.draft.changeset[sif].map!{|x| JSON.parse(x)}
          #         end
          #       end
          #     end
          #     pre_user = user.draft.changeset.map {|x,y| Hash[x, y[0]]}
          #     pre_user.map {|x| user.update(x)}
          #   end
          # end
          
          admin = User.with_role(:admin_reviewer).pluck(:id)
          if user.draft.present?
            user.update(status:"waiting_for_review")
            Notification.send_notification(admin,"Updated User #{user&.name}\'s data " , user&.email, user, current_user&.id, "request_draft")
          end
        end
      else 
        raise GraphQL::ExecutionError, "Request not granted. Please Check Your Request Status"
      end

      
      MutationResult.call(
          obj: { user: user },
          success: user.persisted?,
          errors: user.errors
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