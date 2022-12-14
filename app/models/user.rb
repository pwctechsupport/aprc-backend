class User < ApplicationRecord
  rolify
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Tokenizable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_paper_trail ignore: [:current_sign_in_at,:last_sign_in_at, :sign_in_count, :updated_at, :status]
  has_drafts
  serialize :policy_category, Array
  serialize :main_role, Array


  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy
  has_many :file_attachments, dependent: :destroy
  has_many :policies, dependent: :nullify
  has_many :user_policy_categories
  has_many :policy_categories, through: :user_policy_categories, dependent: :destroy
  has_many :resource_ratings, class_name: "ResourceRating", foreign_key: "user_id", dependent: :destroy
  has_many :risks
  has_many :resource_visits, class_name: "UserResourceVisit", foreign_key: "user_id", dependent: :destroy
  has_many :policy_visits, class_name: "UserPolicyVisit", foreign_key: "user_id", dependent: :destroy
  has_many :controls
  has_many :business_process
  has_many :bookmark, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :activity_controls, dependent: :destroy
  has_many :manuals, dependent: :nullify
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true
  belongs_to :department, optional: true
  devise :database_authenticatable,
         :registerable,
         :recoverable, 
         :devise,
         :validatable,
         :trackable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self
  enum role: %i[customer admin]

  has_many :versions, class_name: "PaperTrail::Version", foreign_key: "whodunnit"
  has_many :tags, dependent: :destroy

  def last_updated_by_user_id
    self&.draft&.whodunnit || self&.versions&.last&.whodunnit
  end

  def policies_by_categories
    # a = Policy.where(policy_category_id: self.policy_category_ids).pluck(:id)
    # b = Policy.where(ancestry: a).pluck(:id)
    # result = Policy.where(id: a+b)
    
    policy_category_ids = self.user_policy_categories.where(draft_id: nil).map{|x| x.policy_category_id}
    policies    = Policy.where(policy_category_id: policy_category_ids)
    policy_ids  = policies.map{|policy| policy.subtree.ids}
    result      = Policy.where(id: policy_ids.flatten)

    return result
  end

  
  def request_edit
    request_edits.last
  end

  def to_humanize
    "#{self.name} : #{self.email}"
  end

  after_initialize :setup_new_user, if: :new_record?

  # Send mail through activejob
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # return first and lastname
  
  private def setup_new_user
    self.role ||= :customer
  end
end
