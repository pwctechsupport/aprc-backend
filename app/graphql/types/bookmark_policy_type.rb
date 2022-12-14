module Types
  class BookmarkPolicyType < BaseObject
    field :id, ID, null: false
    field :policy_id, ID, null: false
    field :user_id, ID, null: false
    field :name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :policy, Types::PolicyType, null: true 
    field :user, Types::UserType, null:true


    
    # field :rating_avg, ID, null: true do
    #   argument :resource_id, ID, required: true
    # end
    # field :rating_all_details_by_array, [ID], null: true
    # field :count_rating_all_details_by_array, [ID], null: true
    # field :total_rating_by_each_user, [ID], null: true

    # def rating_avg(resource_id:)
    #   rating_total = ResourceRating.where(resource_id:resource_id).count
    #   rating_sum = ResourceRating.where(resource_id:resource_id).sum(:rating)
    #   rating_average = rating_sum/rating_total
    #   rating_average.round(1)
    # end

    # def rating_all_details_by_array
    #   ResourceRating.pluck(:user_id, :rating, :resource_id)
    # end
    # def count_rating_all_details_by_array 
    #   ResourceRating.group(:user_id, :rating, :resource_id).count
    # end

    # def total_rating_by_each_user
    #   ResourceRating.group(:user_id).count
    # end


  end
end
