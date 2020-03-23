require 'net/http'

module Mutations
  class CreateResource < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, required: false
    argument :category, String, required: true
    argument :policy_id, ID, required: false
    argument :control_id, ID, required: false
    argument :policy_ids, [ID], required: false 
    argument :control_ids, [ID], required: false 
    argument :business_process_id, ID, required: false 
    argument :status, Types::Enums::Status, required: false
    argument :resupload_link, String, required: false
    argument :tags_attributes, [Types::BaseScalar], required: false

    # argument :type_of_control, Types::Enums::TypeOfControl, required: true



    # return type from the mutation
    field :resource, Types::ResourceType, null: true

    def resolve(args)
      current_user = context[:current_user]

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

      if !(args[:resupload].present?)
        args.delete(:resupload_file_name)
      end

      resource=Resource.new(args)
      resource&.save_draft
      if args[:resupload].present?
        args[:resupload_file_name] = "#{args[:name]}" << resource.resource_file_type(resource)
        resource.update_attributes(resupload: args[:resupload], resupload_file_name: args[:resupload_file_name])
      
      end
      admin = User.with_role(:admin_reviewer).pluck(:id)
      if resource.id.present?
        Notification.send_notification(admin, resource&.name, resource&.category,resource, current_user&.id, "request_draft")
      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
      end

      
      resource = Resource.find_by(name: args[:name], category: args[:category])
      if resource.category.downcase == "flowchart"
        resource.update(policy_id: nil)
        resource.update(policy_ids: nil)
        resource.update(control_id: nil)
        resource.update(control_ids: nil)
        resource
      else
        resource.update(business_process_id: nil)
        resource
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
  end
end