
module Mutations
  class UpdateResource < Mutations::BaseMutation
    graphql_name "UpdateResource"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, required: false  
    argument :category, String, required: false 
    argument :policy_ids, [ID], required: false 
    argument :control_ids, [ID], required: false 
    argument :policy_id, ID, required: false
    argument :control_id, ID, required: false
    argument :business_process_id, ID, required: false 
    argument :status, Types::Enums::Status, required: false
    argument :resupload_link, String, required: false
    argument :tags_attributes, [Types::BaseScalar], required: false
    argument :last_updated_by, String, required: false
    argument :last_updated_at, String, required: false





    field :resource, Types::ResourceType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      resource = Resource.find(id)
      resource_name = resource&.name

      if resource&.request_edits&.last&.approved?
        if resource.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          if args[:control_ids].present? || args[:policy_ids].present?
            args[:is_related] = true
          end
          if args[:resupload_link].present?
            url = URI.parse(args[:resupload_link])
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = (url.scheme == "https")

            http.start do |http|
              if http.head(url.request_uri)['Content-Type'].include? "text/html"
                if args[:resupload_file_name].present?
                  args.delete(:resupload_file_name)
                end
              else
                args[:resupload] = URI.parse(args[:resupload_link])
              end
            end 
          end

          if args[:category].present?
            enum_list = EnumList&.find_by(category_type: "Category", name: args[:category]) || EnumList&.find_by(category_type: "Category", code: args[:category])
            if enum_list ==  nil 
              kode = args[:category].gsub("_"," ").titlecase
              EnumList.create(name: args[:category], category_type: "Category", code: kode)
            end
            enum_list = EnumList&.find_by(category_type: "Category", name: args[:category]) || EnumList&.find_by(category_type: "Category", code: args[:category])
            args[:category] = enum_list&.code
          end
          
          
          if args[:tags_attributes].present?
            act = args[:tags_attributes]
            if act&.first&.class == ActionController::Parameters
              activities = act.collect {|x| x.permit(:id,:_destroy,:x_coordinates,:y_coordinates, :body, :resource_id, :business_process_id, :image_name, :user_id, :risk_id, :control_id)}
              args.delete(:tags_attributes)
              args[:tags_attributes]= activities.collect{|x| x.to_h}
              args[:tags_attributes].first["user_id"] = current_user.id
            end
          end

          
          args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
          args[:last_updated_at] = Time.now
          prev_control = []
          prev_policy = []
          if args[:control_ids].present?
            control = args[:control_ids]
            args.delete(:control_ids)
            if resource&.resource_controls&.present? && (resource&.resource_controls.where(draft_id: nil).present? || resource&.resource_controls.where.not(draft_id: nil).present?)
              resource.resource_controls.each do |pb|
                if pb&.draft_id.present?
                  prev_control.push(pb&.id)
                end
              end
            end
          end
          if args[:policy_ids].present?
            policy = args[:policy_ids]
            args.delete(:policy_ids)
            if resource&.policy_resources&.present? && (resource&.policy_resources.where(draft_id: nil).present? || resource&.policy_resources.where.not(draft_id: nil).present?)
              resource.policy_resources.each do |pb|
                if pb&.draft_id.present?
                  prev_policy.push(pb&.id)
                end
              end
            end
          end
          resource.attributes = args
          resource.save_draft
          if resource&.draft_id.present?
            if resource.draft.event == "update"
              pre_res = resource.draft.changeset.map {|x,y| Hash[x, y[0]]}
              pre_res.map {|x| resource.update(x)}
            end
          end
          resource.name = resource_name
          
          if resource.resupload.present?
            if !(args[:resupload].present?) && args[:name].present?
              args[:resupload_file_name] = "#{args[:name]}" << resource.resource_file_type(resource)
              resource.update_attributes!(resupload: resource.resupload, resupload_file_name: args[:resupload_file_name])
            elsif args[:resupload].present? && args[:name].present?
              args[:resupload_file_name] = "#{args[:name]}" << resource.resource_file_type(resource)
              resource.update_attributes!(resupload: args[:resupload], resupload_file_name: args[:resupload_file_name],base_64_file: args[:resupload])
            end     
          end

          if control.present?
            control.each do |con|
              res_con = ResourceControl.new(resource_id: resource&.id, control_id: con )
              res_con.save_draft
              if prev_control.present?
                resicon = ResourceControl.where(id:prev_control)
                resicon.destroy_all
              end
            end 
          end
          if policy.present?
            policy.each do |con|
              res_pol = PolicyResource.new(resource_id: resource&.id, policy_id: con )
              res_pol.save_draft
              if prev_policy.present?
                resipol = PolicyResource.where(id:prev_policy)
                resipol.destroy_all
              end
            end 
          end
          
          admin = User.with_role(:admin_reviewer).pluck(:id)
          if resource.draft.present?
            Notification.send_notification(admin, resource&.name, resource&.name,resource, current_user&.id, "request_draft")
            resource.update(status:"waiting_for_review")
          end
        end
      else
        raise GraphQL::ExecutionError, "Request not granted. Please Check Your Request Status"
      end
      
      

      MutationResult.call(
        obj: { resource: resource },
        success: resource.persisted?,
        errors: resource.errors
      )
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