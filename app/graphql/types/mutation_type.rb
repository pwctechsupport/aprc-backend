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

    field :create_bookmark_risk, mutation: Mutations::CreateBookmarkRisk
    field :create_bookmark_control, mutation: Mutations::CreateBookmarkControl
    field :create_bookmark_business_process, mutation: Mutations::CreateBookmarkBusinessProcess
    field :destroy_version, mutation: Mutations::DestroyVersion
    field :destroy_bookmark, mutation: Mutations::DestroyBookmark
    field :destroy_bulk_notification, mutation: Mutations::DestroyBulkNotification
    field :destroy_notification, mutation: Mutations::DestroyNotification

    field :create_user_policy_visit, mutation: Mutations::CreateUserPolicyVisit
    field :create_user_resource_visit, mutation: Mutations::CreateUserResourceVisit


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
    field :destroy_resource_attachment, mutation: Mutations::DestroyResourceAttachment
    field :destroy_manual_attachment, mutation: Mutations::DestroyManualAttachment
    field :destroy_it_system, mutation: Mutations::DestroyItSystem
    field :destroy_business_process, mutation: Mutations::DestroyBusinessProcess
    field :destroy_reference, mutation: Mutations::DestroyReference
  
    field :create_sub_business_process, mutation: Mutations::CreateSubBusinessProcess

    field :admin_update_user, mutation: Mutations::AdminUpdateUser
    field :review_policy_draft, mutation: Mutations::ReviewPolicyDraft
    field :review_policy_category_draft, mutation: Mutations::ReviewPolicyCategoryDraft
    field :review_user_draft, mutation: Mutations::ReviewUserDraft
    field :review_risk_draft, mutation: Mutations::ReviewRiskDraft
    field :review_control_draft, mutation: Mutations::ReviewControlDraft
    field :is_read, mutation: Mutations::IsRead
    field :update_user_password, mutation: Mutations::UpdateUserPassword
    field :create_request_edit, mutation: Mutations::CreateRequestEdit
    field :approve_request_edit, mutation: Mutations::ApproveRequestEdit
    field :create_file_attachment, mutation: Mutations::CreateFileAttachment
    field :update_file_attachment, mutation: Mutations::UpdateFileAttachment
    field :destroy_file_attachment, mutation: Mutations::DestroyFileAttachment
    field :create_activity_control, mutation: Mutations::CreateActivityControl
    field :update_activity_control, mutation: Mutations::UpdateActivityControl
    field :destroy_activity_control, mutation: Mutations::DestroyActivityControl
    field :create_tag, mutation: Mutations::CreateTag
    field :update_tag, mutation: Mutations::UpdateTag
    field :destroy_tag, mutation: Mutations::DestroyTag
    field :create_enum_list, mutation: Mutations::CreateEnumList
    field :update_enum_list, mutation: Mutations::UpdateEnumList
    field :destroy_enum_list, mutation: Mutations::DestroyEnumList
    field :create_department, mutation: Mutations::CreateDepartment
    field :update_department, mutation: Mutations::UpdateDepartment
    field :destroy_department, mutation: Mutations::DestroyDepartment
    field :create_manual, mutation: Mutations::CreateManual
    field :update_manual, mutation: Mutations::UpdateManual
    field :destroy_manual, mutation: Mutations::DestroyManual
    field :push_notification, mutation: Mutations::PushNotification
    field :notif_badges, mutation: Mutations::NotifBadges
    field :review_resource_draft, mutation: Mutations::ReviewResourceDraft
    field :is_visit, mutation: Mutations::IsVisit
    field :update_draft_policy, mutation: Mutations::UpdateDraftPolicy
    field :submit_draft_policy, mutation: Mutations::SubmitDraftPolicy
    field :create_role, mutation: Mutations::CreateRole
    field :destroy_role, mutation: Mutations::DestroyRole
    field :remove_relation, mutation: Mutations::RemoveRelation
    



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
