module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :login, UserType, null: true do
      description "Login for users"
      argument :email, String, required: true
      argument :password, String, required: true
    end
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :destroy_user, mutation: Mutations::DestroyUser
    field :destroy_policy, mutation: Mutations::DestroyPolicy
    field :destroy_policy_category, mutation: Mutations::DestroyPolicyCategory
    field :update_policy, mutation: Mutations::UpdatePolicy
    field :update_policy_category, mutation: Mutations::UpdatePolicyCategory

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
