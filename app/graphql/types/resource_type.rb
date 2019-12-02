module Types
  class ResourceType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :resuploadUrl, String, null: true
    def  resupload_url
      attachment = object.resupload.url
    end
  end
end