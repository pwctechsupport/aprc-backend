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
