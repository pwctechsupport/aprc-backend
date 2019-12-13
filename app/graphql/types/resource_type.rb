module Types
  class ResourceType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :resuploadUrl, String, null: true
    field :category, String, null: true
    field :policy_ids, [ID], null: true
    field :policies, [Types::PolicyType], null: true
    field :control_ids, [Types::ControlType], null: true
    field :controls, [Types::ControlType], null: true
    field :business_process_id, ID, null: true
    field :business_process, Types::BusinessProcessType, null: true
    field :rating, Float, null: true
    field :total_rating, Int, null: true
    field :visit,Int, null: false
    
    def  resupload_url
      attachment = object.resupload.url
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