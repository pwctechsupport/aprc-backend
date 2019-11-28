module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :login, UserType, null: true do
      description "Login for users"
      argument :email, String, required: true
      argument :password, String, required: true
    end
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



    def login(email:, password:)
      user = User.find_for_authentication(email: email)
      return nil if !user
      
      is_valid_for_auth = user.valid_for_authentication?{
        user.valid_password?(password)
      }
      return is_valid_for_auth ? user : nil
    end

    field :create_policy, mutation: Mutations::CreatePolicy
    
    field :create_policy_category, mutation: Mutations::CreatePolicyCategory
  end
end
