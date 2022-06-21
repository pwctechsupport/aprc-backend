module Types
  class ManualType < BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :user, Types::UserType, null: true
    field :resupload_url, String, null: true
    field :file_type, String, null: true
    field :file_size, Integer, null: true
    field :file_name, String, null: true
    field :name, String, null: true
    def resupload_url
      attachment = object.resupload.url
    end

    def file_type
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
    
    def file_size
      content = object.resupload_file_size
    end

    def file_name
      content = object.resupload_file_name
    end

  end
end