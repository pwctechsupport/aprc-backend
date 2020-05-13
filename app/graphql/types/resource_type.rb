  module Types
  class ResourceType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :resuploadUrl, String, null: true
    field :category, String, null: true
    field :control, Types::ControlType, null: true
    field :policy_ids, [Types::PolicyType], null: true
    field :policies, [Types::PolicyType], null: true
    field :control_ids, [Types::ControlType], null: true
    field :controls, [Types::ControlType], null: true
    field :business_process_id, ID, null: true
    field :business_process, Types::BusinessProcessType, null: true
    field :rating, Float, null: true
    field :total_rating, Int, null: true
    field :visit,Int, null: true
    field :resource_file_type, String, null: true
    field :resource_file_size, Integer, null: true
    field :resource_file_name, String, null: true
    field :status, String, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :tags, [Types::TagType], null: true
    field :enum_list, Types::EnumListType, null: true
    field :resupload_link, String, null: true
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    field :has_edit_access, Boolean, null: true
    field :request_status, String, null: true
    field :request_edits, [Types::RequestEditType], null: true
    field :request_edit, Types::RequestEditType, null: true
    field :recent_visit, String, null: true
    field :last_updated_by, String, null: true
    field :created_by, String, null: true
    field :last_updated_at, String, null: true
    field :base_64_file, String, null: true
    field :resource_rating, Types::ResourceRatingType, null: true
    

    def request_edit
      object&.request_edit
    end

    def has_edit_access
      current_user = context[:current_user]
      if object.class == Hash
        empty = []
      else
        object&.request_edits&.where(user_id: current_user&.id)&.last&.state == "approved"
      end
    end

    def request_status
      current_user = context[:current_user]
      if object.class == Hash
        empty = []
      else
        object&.request_edits&.where(user_id: current_user&.id)&.last&.state
      end  
    end

    def enum_list
      enum_list = EnumList.find_by(code: object&.category)
    end
    def  resupload_url
      attachment = object.resupload.url
    end

    def resource_file_type
      content = object.resupload_content_type
      if content === nil
        content_true = ""
      else
        content_true = content.to_s
        if content_true.include? "wordprocessingml"
          content_true = ".docx"
          content_true
        elsif content_true.include? "sheet"
          content_true = ".xlsx"
          content_true
        elsif content_true.include? "presentation"
          content_true = ".pptx"
          content_true
        elsif content_true.include? "plain"
          content_true = ".txt"
          content_true
        else
          if content_true == nil
            content_true = ""
          else
            content_index = content_true.index("/")
            content_name = content_true[content_true.index('/',content_index - 1)..-1]
            content_file = content_name.sub("/","")
            contender = "." << content_file
            contender
          end
        end
      end
    end
    
    def resource_file_size
      content = object.resupload_file_size
    end

    def resource_file_name
      content = object.resupload_file_name
    end

    def rating
      rating_total = object.resource_ratings.count
      rating_sum =  object.resource_ratings.sum(:rating)
      rating_average = rating_sum/rating_total
      rating_average.round(1)
    end

    def total_rating
      rating_total = object.resource_ratings.count
    end
  end
end