class User < ApplicationRecord
  rolify
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Tokenizable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_paper_trail ignore: [:current_sign_in_at,:last_sign_in_at, :sign_in_count, :updated_at]
  has_drafts
  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy
  has_many :policies
  has_many :user_policy_categories
  has_many :policy_categories, through: :user_policy_categories
  has_many :resource_ratings, class_name: "ResourceRating", foreign_key: "user_id", dependent: :destroy
  has_many :risks
  has_many :controls
  has_many :business_process
  has_many :bookmark
  has_many :notifications
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true
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
