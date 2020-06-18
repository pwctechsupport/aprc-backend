module Types
  class ActivityControlType < BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :user, Types::UserType, null: true
    field :activity, String, null: true
    field :guidance, String, null: true
    field :resupload, String, null: true
    field :resuploadFileName, String, null: true
    field :control, Types::ControlType, null: true
    field :guidance_resupload_url, String, null: true
    field :guidance_file_type, String, null: true
    field :guidance_file_size, Integer, null: true
    field :guidance_file_name, String, null: true
    field :is_attachment, Boolean, null: true
    field :draft, Types::VersionType, null: true



    def guidance_resupload_url
      attachment = object.resupload.url
    end

    def guidance_file_type
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
    
    def guidance_file_size
      content = object.resupload_file_size
    end

    def guidance_file_name
      content = object.resupload_file_name
    end

  end
end
