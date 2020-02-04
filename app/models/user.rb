class User < ApplicationRecord
  rolify
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Tokenizable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_paper_trail ignore: [:current_sign_in_at,:last_sign_in_at, :sign_in_count, :updated_at]
  has_drafts
  has_many :policies
  has_many :policy_category, through: :policies
  has_many :resource_ratings
  has_many :bookmark_policies
  has_many :risks
  has_many :controls
  has_many :bookmark_risks
  has_many :bookmark_controls
  has_many :bookmark_business_processes
  has_many :user_policy_categories
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
  def name
    [first_name, last_name].join(' ').strip
  end

  private def setup_new_user
    self.role ||= :customer
  end
end
