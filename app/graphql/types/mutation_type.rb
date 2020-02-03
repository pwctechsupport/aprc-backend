module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :login, UserType, null: true do
      description "Login for users"
      argument :email, String, required: true
      argument :password, String, required: true
    end
    field :forgot_password, mutation: Mutations::ForgotPassword
    field :update_password, mutation: Mutations::UpdatePassword
    # user and policy CRUD
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :destroy_user, mutation: Mutations::DestroyUser
    field :destroy_policy, mutation: Mutations::DestroyPolicy
    field :destroy_policy_category, mutation: Mutations::DestroyPolicyCategory
    field :update_policy, mutation: Mutations::UpdatePolicy
    field :update_policy_category, mutation: Mutations::UpdatePolicyCategory
    field :create_sub_policy, mutation: Mutations::CreateSubPolicy
    field :update_policy_reference, mutation: Mutations::UpdatePolicyReference
    field :create_policy, mutation: Mutations::CreatePolicy
    field :create_policy_category, mutation: Mutations::CreatePolicyCategory   
    field :create_control, mutation: Mutations::CreateControl
    field :update_control, mutation: Mutations::UpdateControl
    field :destroy_control, mutation: Mutations::DestroyControl
    field :create_risk, mutation: Mutations::CreateRisk
    field :update_risk, mutation: Mutations::UpdateRisk
    field :destroy_risk, mutation: Mutations::DestroyRisk
    field :create_description, mutation: Mutations::CreateDescription
    field :update_description, mutation: Mutations::UpdateDescription
    field :destroy_description, mutation: Mutations::DestroyDescription

    field :create_resource_rating, mutation: Mutations::CreateResourceRating
    field :update_resource_rating, mutation: Mutations::UpdateResourceRating
    field :destroy_resource_rating, mutation: Mutations::DestroyResourceRating
    field :create_bookmark_policy, mutation: Mutations::CreateBookmarkPolicy
    field :destroy_bookmark_policy, mutation: Mutations::DestroyBookmarkPolicy

    field :create_bookmark_risk, mutation: Mutations::CreateBookmarkRisk
    field :destroy_bookmark_risk, mutation: Mutations::DestroyBookmarkRisk
    field :create_bookmark_control, mutation: Mutations::CreateBookmarkControl
    field :destroy_bookmark_control, mutation: Mutations::DestroyBookmarkControl
    field :create_bookmark_business_process, mutation: Mutations::CreateBookmarkBusinessProcess
    field :destroy_bookmark_business_process, mutation: Mutations::DestroyBookmarkBusinessProcess

  


    # Attributes CRUD
    field :create_resource, mutation: Mutations::CreateResource
    field :create_it_system, mutation: Mutations::CreateItSystem
    field :create_business_process, mutation: Mutations::CreateBusinessProcess
    field :create_reference, mutation: Mutations::CreateReference

    field :update_resource, mutation: Mutations::UpdateResource
    field :update_it_system, mutation: Mutations::UpdateItSystem
    field :update_business_process, mutation: Mutations::UpdateBusinessProcess
    field :update_reference, mutation: Mutations::UpdateReference

    field :destroy_resource, mutation: Mutations::DestroyResource
    field :destroy_it_system, mutation: Mutations::DestroyItSystem
    field :destroy_business_process, mutation: Mutations::DestroyBusinessProcess
    field :destroy_reference, mutation: Mutations::DestroyReference
  
    field :create_sub_business_process, mutation: Mutations::CreateSubBusinessProcess

    field :create_user_access, mutation: Mutations::CreateUserAccess



    def login(email:, password:)
      user = User.find_for_authentication(email: email)
      return nil if !user
      
      is_valid_for_auth = user.valid_for_authentication?{
        user.valid_password?(password)
      }
      return is_valid_for_auth ? user : nil
    end


  end
end
