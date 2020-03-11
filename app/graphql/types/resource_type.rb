module Types
  class ResourceType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :resuploadUrl, String, null: true
    field :category, String, null: true
    field :policy, Types::PolicyType, null: true
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